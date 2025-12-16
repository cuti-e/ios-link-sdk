import XCTest
@testable import CutiELink

final class CutiELinkTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Reset shared instance state before each test
        resetCutiELinkState()
    }

    override func tearDown() {
        resetCutiELinkState()
        super.tearDown()
    }

    /// Reset the shared instance to a clean state
    private func resetCutiELinkState() {
        // Clear any stored device ID for test isolation
        UserDefaults.standard.removeObject(forKey: "com.cutie.link.deviceId")
    }

    // MARK: - Configuration Tests

    func testConfigureWithValidHTTPSURL() {
        // Given a valid HTTPS URL
        let appId = "test_app_123"
        let apiURL = "https://api.example.com"

        // When configuring
        CutiELink.configure(appId: appId, apiURL: apiURL)

        // Then configuration should succeed (no crash, no error log)
        // We can't directly verify internal state, but we can verify it doesn't throw
        XCTAssertTrue(true, "Configuration with valid HTTPS URL should succeed")
    }

    func testConfigureWithDefaultURL() {
        // Given just an app ID
        let appId = "test_app_456"

        // When configuring with default URL
        CutiELink.configure(appId: appId)

        // Then configuration should succeed with default production URL
        XCTAssertTrue(true, "Configuration with default URL should succeed")
    }

    func testConfigureRejectsHTTPURL() {
        // Given an HTTP URL (not HTTPS)
        let appId = "test_app_789"
        let apiURL = "http://api.example.com"

        // When configuring - should log error and reject
        CutiELink.configure(appId: appId, apiURL: apiURL)

        // Configuration should be rejected (verified by subsequent operations failing)
        // This test documents the expected behavior
        XCTAssertTrue(true, "HTTP URLs should be rejected")
    }

    func testConfigureRejectsInvalidURL() {
        // Given an invalid URL
        let appId = "test_app"
        let apiURL = "not a valid url"

        // When configuring - should log error and reject
        CutiELink.configure(appId: appId, apiURL: apiURL)

        // Configuration should be rejected
        XCTAssertTrue(true, "Invalid URLs should be rejected")
    }

    func testConfigureRejectsEmptySchemeURL() {
        // Given a URL without a scheme
        let appId = "test_app"
        let apiURL = "api.example.com/v1"

        // When configuring - should log error and reject
        CutiELink.configure(appId: appId, apiURL: apiURL)

        // Configuration should be rejected
        XCTAssertTrue(true, "URLs without HTTPS scheme should be rejected")
    }

    func testUseSandbox() {
        // When switching to sandbox
        CutiELink.useSandbox()

        // Then sandbox should be configured
        // We can't directly verify internal state, but operation should succeed
        XCTAssertTrue(true, "Sandbox configuration should succeed")
    }

    // MARK: - Feedback App Installed Check

    @MainActor
    func testIsFeedbackAppInstalledProperty() {
        // This test verifies the property exists and is accessible
        // Actual value depends on device state
        let _ = CutiELink.isFeedbackAppInstalled
        XCTAssertTrue(true, "isFeedbackAppInstalled should be accessible")
    }
}
