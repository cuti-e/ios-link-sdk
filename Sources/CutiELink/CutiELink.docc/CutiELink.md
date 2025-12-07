# ``CutiELink``

Connect your app to the Cuti-E Feedback App with a single line of code.

## Overview

CutiELink is a lightweight SDK that lets users jump from your app directly into the Cuti-E Feedback App. Instead of embedding the full feedback UI, you hand off to a dedicated app where users can manage all their feedback conversations in one place.

### When to Use CutiELink

Use CutiELink when you want to:
- Keep your app binary small
- Let users manage feedback across multiple apps
- Avoid embedding UI components

Use the full [CutiE SDK](https://github.com/cuti-e/ios-sdk) when you want:
- In-app feedback UI
- Push notifications
- Subscription management

## Getting Started

### Installation

Add CutiELink using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/cuti-e/ios-link-sdk", from: "1.0.0")
]
```

### Configuration

Configure once at app launch with your App ID from the admin dashboard:

```swift
import CutiELink

@main
struct MyApp: App {
    init() {
        CutiELink.configure(appId: "your_app_id")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

Get your App ID from [admin.cuti-e.com](https://admin.cuti-e.com) under Settings > Apps.

### Open the Feedback App

When users want to send feedback:

```swift
Button("Send Feedback") {
    Task {
        try await CutiELink.openFeedbackApp()
    }
}
```

If the Feedback App isn't installed, users are redirected to the App Store.

## Topics

### Essentials

- ``CutiELink``

### Errors

- ``CutiELinkError``
