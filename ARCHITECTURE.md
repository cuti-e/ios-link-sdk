# CutiELink SDK Architecture

This document describes the architecture of the CutiELink iOS SDK using C4 diagrams.

## Overview

CutiELink is a lightweight SDK that enables "Open in Feedback App" functionality. Unlike the full CutiE SDK (which embeds feedback UI), CutiELink simply links users to the standalone Cuti-E Feedback App via deep links.

---

## C4 Model

### Level 1: System Context

Shows how the SDK connects apps to the Cuti-E ecosystem.

```mermaid
flowchart TB
    subgraph "User's Device"
        HostApp["Host iOS App<br/>(Your App)"]
        SDK["CutiELink SDK"]
        FeedbackApp["Cuti-E Feedback App"]

        HostApp --> SDK
        SDK -->|"Deep Link<br/>cutie://link?token=xxx"| FeedbackApp
    end

    subgraph "Cuti-E Platform"
        API["Cuti-E API<br/>(Cloudflare Workers)"]
        Admin["Admin Dashboard"]
    end

    SDK <-->|"HTTPS<br/>Generate Token"| API
    FeedbackApp <-->|"Sync Conversations"| API
    Admin <-->|"Manage Feedback"| API

    User((App User))
    User --> HostApp
    User --> FeedbackApp
```

### Comparison with Full SDK

```mermaid
flowchart LR
    subgraph "Option A: CutiE SDK"
        App1["iOS App"]
        SDK1["CutiE SDK<br/>(Full)"]
        UI1["Embedded<br/>Feedback UI"]

        App1 --> SDK1
        SDK1 --> UI1
    end

    subgraph "Option B: CutiELink SDK"
        App2["iOS App"]
        SDK2["CutiELink SDK<br/>(Minimal)"]
        FBApp["Feedback App<br/>(Standalone)"]

        App2 --> SDK2
        SDK2 -.->|"Deep Link"| FBApp
    end

    API["Cuti-E API"]
    SDK1 <--> API
    SDK2 <--> API
    FBApp <--> API
```

---

### Level 2: Container Diagram

Shows the SDK structure and dependencies.

```mermaid
flowchart TB
    subgraph sdk["CutiELink SDK (Swift Package)"]
        CutiELink["CutiELink<br/>(Main Class)"]
        Result["CutiELinkResult<br/>(Response Model)"]
        Error["CutiELinkError<br/>(Error Types)"]

        CutiELink --> Result
        CutiELink --> Error
    end

    subgraph deps["System Dependencies"]
        UIKit["UIKit<br/>(Deep Links)"]
        Foundation["Foundation<br/>(Networking)"]
        UserDefaults["UserDefaults<br/>(Device ID)"]
    end

    CutiELink --> UIKit
    CutiELink --> Foundation
    CutiELink --> UserDefaults
```

---

### Level 3: Component Diagram

Shows internal structure of the CutiELink class.

```mermaid
flowchart TB
    subgraph "CutiELink"
        subgraph "Configuration"
            configure["configure(appId:)"]
            useSandbox["useSandbox()"]
            appId["appId: String?"]
            baseURL["baseURL: String"]
        end

        subgraph "Public API"
            openApp["openFeedbackApp()"]
            generateCode["generateLinkCode()"]
            isInstalled["isFeedbackAppInstalled"]
        end

        subgraph "Internal"
            generateToken["generateToken()"]
            getDeviceId["getDeviceId()"]
        end
    end

    configure --> appId
    configure --> baseURL
    useSandbox --> baseURL

    openApp --> generateCode
    generateCode --> generateToken
    generateCode --> getDeviceId
    isInstalled -->|"canOpenURL"| DeepLink

    generateToken -->|"POST /v1/feedback-app/generate-token"| API["Cuti-E API"]
    generateCode -->|"cutie://link?token=xxx"| DeepLink["Deep Link"]
```

---

## Data Flow Diagrams

### Open Feedback App Flow

```mermaid
sequenceDiagram
    participant User
    participant App as Host App
    participant SDK as CutiELink
    participant API as Cuti-E API
    participant FB as Feedback App

    User->>App: Tap "Open in Feedback App"
    App->>SDK: openFeedbackApp()

    SDK->>SDK: getDeviceId()
    Note over SDK: UUID from UserDefaults

    SDK->>API: POST /v1/feedback-app/generate-token
    Note over SDK,API: Headers: X-App-ID, X-Device-ID
    API-->>SDK: { token: "xxx" }

    SDK->>SDK: canOpenURL("cutie://")

    alt Feedback App Installed
        SDK->>FB: Open cutie://link?token=xxx
        FB->>API: Validate & link device
        FB-->>User: Show linked inbox
        SDK-->>App: Success (true)
    else Not Installed
        SDK-->>App: Throw feedbackAppNotInstalled
        App-->>User: Show install prompt
    end
```

### Generate Link Code Flow (Manual Fallback)

```mermaid
sequenceDiagram
    participant App as Host App
    participant SDK as CutiELink
    participant API as Cuti-E API

    App->>SDK: generateLinkCode()
    SDK->>API: POST /v1/feedback-app/generate-token
    API-->>SDK: { token: "abc123..." }

    SDK->>SDK: Try deep link

    alt Deep Link Opens
        SDK-->>App: CutiELinkResult(code, didOpenApp: true)
    else Deep Link Fails
        SDK-->>App: CutiELinkResult(code, didOpenApp: false)
        App->>App: Show code to user
        Note over App: "Enter code ABC123 in Feedback App"
    end
```

---

## API Communication

### Token Generation Request

```mermaid
flowchart LR
    subgraph Request
        direction TB
        Method["POST"]
        URL["/v1/feedback-app/generate-token"]
        Headers["X-App-ID: app_xxx<br/>X-Device-ID: uuid<br/>Content-Type: application/json"]
        Body["{ device_id, app_id }"]
    end

    subgraph Response
        direction TB
        Status["200 OK"]
        RespBody["{ token: 'link_token_xxx' }"]
    end

    Request -->|"HTTPS"| API["Cuti-E API"]
    API --> Response
```

### Error Handling

```mermaid
flowchart TB
    subgraph "CutiELinkError"
        notConfigured["notConfigured<br/>No appId set"]
        invalidCredentials["invalidCredentials<br/>401 response"]
        serverError["serverError(code)<br/>Non-200 response"]
        feedbackAppNotInstalled["feedbackAppNotInstalled<br/>canOpenURL = false"]
        invalidResponse["invalidResponse<br/>Missing token in JSON"]
    end

    Configure -->|"Missing"| notConfigured
    API -->|"401"| invalidCredentials
    API -->|"5xx"| serverError
    API -->|"Malformed"| invalidResponse
    DeepLink -->|"Not installed"| feedbackAppNotInstalled
```

---

## Deep Link Integration

### URL Scheme

```mermaid
flowchart LR
    SDK["CutiELink SDK"]

    subgraph "Deep Link"
        Scheme["cutie://"]
        Path["link"]
        Param["?token=xxx"]
    end

    subgraph "Feedback App"
        Handler["URL Handler"]
        Link["Link Device"]
        Inbox["Show Inbox"]
    end

    SDK --> Scheme --> Path --> Param
    Param --> Handler --> Link --> Inbox
```

### Info.plist Requirement

```mermaid
flowchart TB
    subgraph "Host App Info.plist"
        Key["LSApplicationQueriesSchemes"]
        Value["cutie"]
    end

    subgraph "SDK Check"
        canOpen["canOpenURL('cutie://')"]
    end

    Key --> Value
    Value -->|"Allows"| canOpen
    canOpen -->|"true/false"| Result["isFeedbackAppInstalled"]
```

---

## Security

```mermaid
flowchart TB
    subgraph "Transport"
        HTTPS["HTTPS Only"]
        Validate["URL Validation"]
    end

    subgraph "Authentication"
        AppID["X-App-ID Header"]
        DeviceID["X-Device-ID Header"]
    end

    subgraph "Device Identity"
        UUID["UUID (Generated)"]
        Persist["UserDefaults<br/>(Per-install)"]
        Lock["NSLock<br/>(Thread-safe)"]
    end

    HTTPS --> Validate
    AppID --> Auth["API Auth"]
    DeviceID --> Auth
    UUID --> Persist
    Lock --> UUID
```

---

## Module Structure

```
Sources/CutiELink/
└── CutiELink.swift          # Everything in one file
    ├── CutiELink (class)     # Main singleton
    ├── CutiELinkResult       # Success response
    └── CutiELinkError        # Error types
```

### Public API Surface

| Method/Property | Description |
|-----------------|-------------|
| `configure(appId:apiURL:)` | Set App ID and optional custom API URL |
| `useSandbox()` | Switch to sandbox environment |
| `openFeedbackApp()` | Generate token and open Feedback App |
| `generateLinkCode()` | Generate token with manual fallback |
| `isFeedbackAppInstalled` | Check if Feedback App is installed |

---

## Platform Requirements

| Requirement | Value |
|-------------|-------|
| iOS | 14.0+ |
| Swift | 5.7+ |
| Dependencies | UIKit, Foundation only |
| Size | ~3KB compiled |

---

## Comparison: CutiE vs CutiELink

| Feature | CutiE SDK | CutiELink SDK |
|---------|-----------|---------------|
| Feedback Form | Embedded | External app |
| Push Notifications | Yes | No (handled by Feedback App) |
| Inbox View | Yes | No (handled by Feedback App) |
| App Attest | Yes | No |
| Certificate Pinning | Yes | No |
| Size | ~50KB | ~3KB |
| Complexity | Full-featured | Minimal |
| Use Case | Self-contained feedback | Link to Feedback App |
