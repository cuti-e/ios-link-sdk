import XCTest
@testable import CutiELink

final class CutiELinkErrorTests: XCTestCase {

    // MARK: - Error Description Tests

    func testNotConfiguredErrorDescription() {
        let error = CutiELinkError.notConfigured
        XCTAssertEqual(
            error.errorDescription,
            "CutiELink not configured. Call CutiELink.configure(appId:) first."
        )
    }

    func testInvalidCredentialsErrorDescription() {
        let error = CutiELinkError.invalidCredentials
        XCTAssertEqual(error.errorDescription, "Invalid App ID or API key")
    }

    func testInvalidURLErrorDescription() {
        let error = CutiELinkError.invalidURL
        XCTAssertEqual(error.errorDescription, "Invalid API URL")
    }

    func testInvalidDeepLinkErrorDescription() {
        let error = CutiELinkError.invalidDeepLink
        XCTAssertEqual(error.errorDescription, "Failed to create deep link")
    }

    func testInvalidResponseErrorDescription() {
        let error = CutiELinkError.invalidResponse
        XCTAssertEqual(error.errorDescription, "Invalid server response")
    }

    func testServerErrorDescription() {
        let error = CutiELinkError.serverError(500)
        XCTAssertEqual(error.errorDescription, "Server error: 500")
    }

    func testServerErrorWithDifferentCodes() {
        XCTAssertEqual(CutiELinkError.serverError(400).errorDescription, "Server error: 400")
        XCTAssertEqual(CutiELinkError.serverError(403).errorDescription, "Server error: 403")
        XCTAssertEqual(CutiELinkError.serverError(404).errorDescription, "Server error: 404")
        XCTAssertEqual(CutiELinkError.serverError(503).errorDescription, "Server error: 503")
    }

    func testFeedbackAppNotInstalledErrorDescription() {
        let error = CutiELinkError.feedbackAppNotInstalled
        XCTAssertEqual(error.errorDescription, "Cuti-E Feedback App is not installed")
    }

    // MARK: - Error Conformance Tests

    func testErrorConformsToLocalizedError() {
        let error: LocalizedError = CutiELinkError.notConfigured
        XCTAssertNotNil(error.errorDescription)
    }

    func testAllErrorCasesHaveDescriptions() {
        let allErrors: [CutiELinkError] = [
            .notConfigured,
            .invalidCredentials,
            .invalidURL,
            .invalidDeepLink,
            .invalidResponse,
            .serverError(500),
            .feedbackAppNotInstalled
        ]

        for error in allErrors {
            XCTAssertNotNil(error.errorDescription, "Error \(error) should have a description")
            XCTAssertFalse(error.errorDescription!.isEmpty, "Error \(error) description should not be empty")
        }
    }
}
