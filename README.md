# CutiELink SDK

A minimal iOS SDK for connecting your app to the Cuti-E Feedback App.

## Overview

CutiELink enables the "Open in Feedback App" button in your app. When users tap it, they're seamlessly linked to the Cuti-E Feedback App where they can manage all their feedback across apps.

**This SDK is different from the main CutiE SDK:**
- **CutiE SDK** - Full feedback form embedded in your app
- **CutiELink SDK** - Just links to the standalone Feedback App (simpler)

## Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/cuti-e/ios-link-sdk.git", from: "1.0.0")
]
```

Or in Xcode: File > Add Package Dependencies > paste the URL.

## Usage

### 1. Configure at App Launch

```swift
import CutiELink

@main
struct MyApp: App {
    init() {
        CutiELink.configure(apiKey: "your-api-key")
    }
    // ...
}
```

### 2. Add "Open in Feedback App" Button

```swift
import CutiELink

struct SettingsView: View {
    var body: some View {
        Button("Open in Feedback App") {
            Task {
                do {
                    try await CutiELink.openFeedbackApp()
                } catch {
                    print("Error: \(error)")
                }
            }
        }
    }
}
```

That's it! Two lines of code.

## API Reference

### Configuration

```swift
// Required: Set your API key
CutiELink.configure(apiKey: "your-key")

// Optional: Use sandbox for testing
CutiELink.useSandbox()
```

### Opening Feedback App

```swift
// Open Feedback App (generates magic link)
try await CutiELink.openFeedbackApp()

// Check if Feedback App is installed
if CutiELink.isFeedbackAppInstalled {
    // App is installed
}
```

## Requirements

- iOS 14.0+
- Swift 5.7+

## Info.plist Setup

To check if the Feedback App is installed, add to your Info.plist:

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>cutie</string>
</array>
```

## How It Works

1. User taps "Open in Feedback App" in your app
2. SDK generates a secure link token via API
3. SDK opens `cutie://link?token=xxx` deep link
4. Feedback App receives token and links the device
5. User can now manage feedback from your app

## License

MIT License
