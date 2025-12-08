# GitHub Copilot Instructions for CutiELink SDK

This file provides guidance for GitHub Copilot code review and code completion in this repository.

## Project Overview

**CutiELink SDK** is a minimal iOS SDK for connecting apps to the Cuti-E Feedback App via deep linking.

**Package:** Swift Package Manager
**Minimum iOS:** 14.0+
**Repository:** https://github.com/cuti-e/ios-link-sdk (public)

This SDK is intentionally minimal - it only handles deep link generation and app opening. The full feedback functionality is in the standalone Cuti-E Feedback App.

## Code Review Focus Areas

### Public API Design (Critical)
- Keep API surface minimal - this is a "link only" SDK
- All public methods must have documentation
- Maintain backward compatibility
- Static methods preferred for simple operations

### Security
- Link tokens are short-lived and single-use
- Never store sensitive data locally
- Validate API responses before processing

### SDK Architecture
```swift
// Simple static API
CutiELink.configure(appId: "...")
try await CutiELink.openFeedbackApp()

// Optional sandbox mode
CutiELink.useSandbox()
```

## API Patterns

### Configuration
```swift
/// Configure the SDK with your App ID
/// - Parameter appId: Your App ID from admin.cuti-e.com
public static func configure(appId: String)

/// Switch to sandbox environment for testing
public static func useSandbox()
```

### Core Functionality
```swift
/// Open the Cuti-E Feedback App with device linking
/// - Throws: CutiELinkError if link generation fails
public static func openFeedbackApp() async throws

/// Check if the Feedback App is installed
public static var isFeedbackAppInstalled: Bool
```

## Testing Requirements

### Before Creating PRs
```bash
# Build for iOS
xcodebuild build \
  -scheme CutiELink \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
  -skipPackagePluginValidation

# Build documentation
xcodebuild docbuild \
  -scheme CutiELink \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
  -derivedDataPath .build
```

## Common Pitfalls

- **URL scheme registration**: Apps using this SDK need `cutie` in LSApplicationQueriesSchemes
- **Deep link handling**: iOS may prompt user to open in Feedback App
- **API availability**: Sandbox and production use different endpoints

## File Organization

```
ios-link-sdk/
├── Sources/CutiELink/
│   ├── CutiELink.swift       # Main SDK entry point
│   ├── Models/               # Data models
│   └── Errors/               # Error types
├── Tests/CutiELinkTests/
└── Package.swift
```

## Documentation Requirements

### DocC Comments
```swift
/// Opens the Cuti-E Feedback App and links this device.
///
/// This method:
/// 1. Generates a secure link token via the API
/// 2. Opens the Feedback App via deep link
/// 3. The Feedback App completes the linking process
///
/// - Throws: `CutiELinkError.notConfigured` if `configure()` wasn't called
/// - Throws: `CutiELinkError.networkError` if token generation fails
/// - Throws: `CutiELinkError.appNotInstalled` if Feedback App isn't installed
public static func openFeedbackApp() async throws
```

## Code Style

- Use Swift naming conventions
- Keep the SDK minimal - avoid feature creep
- Prefer static methods for stateless operations
- Use descriptive error types
- Document all public API with DocC comments
