# Changelog

All notable changes to the CutiELink iOS SDK will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2025-12-10

### Added
- `generateLinkCode()` method for manual code fallback when universal links fail

### Changed
- Throw error when Feedback App is not installed instead of silently failing
- CI: Use self-hosted Linux runners for faster builds

## [1.1.1] - 2025-12-06

### Changed
- CI: Bump actions/github-script from 7 to 8
- CI: Bump actions/checkout from 4 to 6
- CI: Migrate to self-hosted macOS runner
- CI: Add auto-merge workflow for Dependabot PRs

### Fixed
- CI: Add checks:read permission to auto-merge workflow

## [1.1.0] - 2025-11-28

### Added
- Anonymous device registration - API key no longer required
- DocC documentation catalog

### Changed
- Updated README to use `appId` configuration
- Updated DocC examples to use `configure(appId:)`

## [1.0.0] - 2025-11-15

### Added
- Initial release
- Deep linking to Cuti-E Feedback app
- Device linking via QR code or universal links
- DeviceCheck integration for secure device identification
- App Store fallback when Feedback App not installed

[1.2.0]: https://github.com/cuti-e/ios-link-sdk/compare/1.1.1...1.2.0
[1.1.1]: https://github.com/cuti-e/ios-link-sdk/compare/1.1.0...1.1.1
[1.1.0]: https://github.com/cuti-e/ios-link-sdk/compare/1.0.0...1.1.0
[1.0.0]: https://github.com/cuti-e/ios-link-sdk/releases/tag/1.0.0
