# Changelog

All notable changes to the CutiELink iOS SDK will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.3.0](https://github.com/cuti-e/ios-link-sdk/compare/1.2.0...1.3.0) (2026-02-14)


### Features

* Add SSL certificate pinning with expiry monitoring ([#33](https://github.com/cuti-e/ios-link-sdk/issues/33)) ([987e2bf](https://github.com/cuti-e/ios-link-sdk/commit/987e2bf0beb1dd0723b9f5e18cc95f248d742db7))


### Bug Fixes

* Add HTTPS enforcement in configure() ([#28](https://github.com/cuti-e/ios-link-sdk/issues/28)) ([54b9d1d](https://github.com/cuti-e/ios-link-sdk/commit/54b9d1d22b1e95475e2a1fa25a19939c388f54e3))
* Add thread safety to getDeviceId() ([#27](https://github.com/cuti-e/ios-link-sdk/issues/27)) ([d3ce709](https://github.com/cuti-e/ios-link-sdk/commit/d3ce7092833543ffc7c4b943e02f1aa6c9f814f6))
* **ci:** use macOS runner for release-please workflow ([#40](https://github.com/cuti-e/ios-link-sdk/issues/40)) ([d98953e](https://github.com/cuti-e/ios-link-sdk/commit/d98953e3edcfa693f14d8f557ee6efd82ad1ee57))
* Simplify pin-expiry-check workflow for Dependabot compatibility ([#36](https://github.com/cuti-e/ios-link-sdk/issues/36)) ([a20cbfb](https://github.com/cuti-e/ios-link-sdk/commit/a20cbfb6196ed851463c26dc48796428c56f18e8))
* Use self-hosted macOS runner for pin-expiry-check workflow ([#34](https://github.com/cuti-e/ios-link-sdk/issues/34)) ([21d6b57](https://github.com/cuti-e/ios-link-sdk/commit/21d6b579b809950e4a58695f764b0cbded2c1ec3))

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
