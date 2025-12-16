import XCTest
@testable import CutiELink

final class DeviceIdTests: XCTestCase {

    private let deviceIdKey = "com.cutie.link.deviceId"

    override func setUp() {
        super.setUp()
        // Clear device ID before each test
        UserDefaults.standard.removeObject(forKey: deviceIdKey)
    }

    override func tearDown() {
        // Clean up after tests
        UserDefaults.standard.removeObject(forKey: deviceIdKey)
        super.tearDown()
    }

    // MARK: - Device ID Generation Tests

    func testGetDeviceIdGeneratesUUID() {
        let deviceId = CutiELink.shared.getDeviceId()

        // Should be a valid UUID format
        XCTAssertNotNil(UUID(uuidString: deviceId), "Device ID should be a valid UUID")
    }

    func testGetDeviceIdPersistsToUserDefaults() {
        let deviceId = CutiELink.shared.getDeviceId()

        // Should be stored in UserDefaults
        let storedId = UserDefaults.standard.string(forKey: deviceIdKey)
        XCTAssertEqual(storedId, deviceId)
    }

    func testGetDeviceIdReturnsSameValueOnSubsequentCalls() {
        let firstCall = CutiELink.shared.getDeviceId()
        let secondCall = CutiELink.shared.getDeviceId()
        let thirdCall = CutiELink.shared.getDeviceId()

        XCTAssertEqual(firstCall, secondCall)
        XCTAssertEqual(secondCall, thirdCall)
    }

    func testGetDeviceIdReturnsExistingValueFromUserDefaults() {
        // Pre-populate UserDefaults with a known value
        let existingId = "existing-device-id-12345"
        UserDefaults.standard.set(existingId, forKey: deviceIdKey)

        let deviceId = CutiELink.shared.getDeviceId()

        XCTAssertEqual(deviceId, existingId)
    }

    func testGetDeviceIdGeneratesNewIdWhenNotStored() {
        // Ensure nothing is stored
        XCTAssertNil(UserDefaults.standard.string(forKey: deviceIdKey))

        let deviceId = CutiELink.shared.getDeviceId()

        // Should generate a new ID
        XCTAssertFalse(deviceId.isEmpty)
        XCTAssertNotNil(UUID(uuidString: deviceId))
    }

    // MARK: - Thread Safety Tests

    func testGetDeviceIdIsThreadSafe() {
        let expectation = XCTestExpectation(description: "Concurrent device ID access")
        expectation.expectedFulfillmentCount = 100

        var deviceIds = [String]()
        let lock = NSLock()

        // Dispatch 100 concurrent requests
        for _ in 0..<100 {
            DispatchQueue.global().async {
                let id = CutiELink.shared.getDeviceId()

                lock.lock()
                deviceIds.append(id)
                lock.unlock()

                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 10.0)

        // All IDs should be the same (thread-safe generation)
        let uniqueIds = Set(deviceIds)
        XCTAssertEqual(uniqueIds.count, 1, "All concurrent calls should return the same device ID")
    }

    func testGetDeviceIdDoesNotGenerateMultipleIds() {
        let expectation = XCTestExpectation(description: "No duplicate ID generation")
        expectation.expectedFulfillmentCount = 50

        let group = DispatchGroup()

        // Start multiple concurrent requests before any can complete
        for _ in 0..<50 {
            group.enter()
            DispatchQueue.global().async {
                _ = CutiELink.shared.getDeviceId()
                group.leave()
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 10.0)

        // Should only have one ID stored
        let storedId = UserDefaults.standard.string(forKey: deviceIdKey)
        XCTAssertNotNil(storedId)

        // Verify it's a valid UUID
        XCTAssertNotNil(UUID(uuidString: storedId!))
    }
}
