import XCTest
@testable import CutiELink

final class CutiELinkResultTests: XCTestCase {

    // MARK: - Initialization Tests

    func testResultInitialization() {
        let result = CutiELinkResult(linkCode: "abc123def456", didOpenApp: true)

        XCTAssertEqual(result.linkCode, "abc123def456")
        XCTAssertTrue(result.didOpenApp)
    }

    func testResultWithAppNotOpened() {
        let result = CutiELinkResult(linkCode: "token123", didOpenApp: false)

        XCTAssertEqual(result.linkCode, "token123")
        XCTAssertFalse(result.didOpenApp)
    }

    // MARK: - Short Code Tests

    func testShortCodeReturnsFirst8Characters() {
        let result = CutiELinkResult(linkCode: "abcdefghijklmnop", didOpenApp: true)

        XCTAssertEqual(result.shortCode, "ABCDEFGH")
    }

    func testShortCodeIsUppercased() {
        let result = CutiELinkResult(linkCode: "abcd1234rest", didOpenApp: true)

        XCTAssertEqual(result.shortCode, "ABCD1234")
    }

    func testShortCodeWithExactly8Characters() {
        let result = CutiELinkResult(linkCode: "12345678", didOpenApp: true)

        XCTAssertEqual(result.shortCode, "12345678")
    }

    func testShortCodeWithLessThan8Characters() {
        let result = CutiELinkResult(linkCode: "abc", didOpenApp: true)

        XCTAssertEqual(result.shortCode, "ABC")
    }

    func testShortCodeWithEmptyLinkCode() {
        let result = CutiELinkResult(linkCode: "", didOpenApp: true)

        XCTAssertEqual(result.shortCode, "")
    }

    func testShortCodeWithMixedCase() {
        let result = CutiELinkResult(linkCode: "AbCdEfGhIjKl", didOpenApp: true)

        XCTAssertEqual(result.shortCode, "ABCDEFGH")
    }

    func testShortCodeWithSpecialCharacters() {
        let result = CutiELinkResult(linkCode: "abc-def_123", didOpenApp: true)

        XCTAssertEqual(result.shortCode, "ABC-DEF_")
    }

    // MARK: - UUID-style Link Code Tests

    func testShortCodeWithUUIDStyleToken() {
        // Typical UUID format that might come from API
        let result = CutiELinkResult(linkCode: "550e8400-e29b-41d4-a716-446655440000", didOpenApp: true)

        XCTAssertEqual(result.shortCode, "550E8400")
    }

    func testShortCodePreservesNumbersAndLetters() {
        let result = CutiELinkResult(linkCode: "a1b2c3d4e5f6", didOpenApp: true)

        XCTAssertEqual(result.shortCode, "A1B2C3D4")
    }
}
