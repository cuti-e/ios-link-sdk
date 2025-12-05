import UIKit

/// CutiELink - Simple SDK for linking apps to the Cuti-E Feedback App
///
/// Usage:
/// ```swift
/// // Configure once at app launch
/// CutiELink.configure(apiKey: "your-api-key")
///
/// // When user taps "Open in Feedback App"
/// try await CutiELink.openFeedbackApp()
/// ```
public final class CutiELink {

    // MARK: - Singleton

    public static let shared = CutiELink()
    private init() {}

    // MARK: - Configuration

    private var apiKey: String?
    private var appId: String?
    private var baseURL = "https://api.cuti-e.com"

    /// Configure CutiELink with your API key
    /// - Parameters:
    ///   - apiKey: Your Cuti-E API key from the admin dashboard
    ///   - appId: Optional app identifier (for multi-app setups)
    public static func configure(apiKey: String, appId: String? = nil) {
        shared.apiKey = apiKey
        shared.appId = appId
    }

    /// Configure for sandbox/testing
    public static func useSandbox() {
        shared.baseURL = "https://cutie-worker-sandbox.invotekas.workers.dev"
    }

    // MARK: - Public API

    /// Open the Cuti-E Feedback App
    ///
    /// Generates a link token and opens the Feedback App via deep link.
    /// If the Feedback App isn't installed, opens the App Store.
    ///
    /// - Returns: True if the app was opened successfully
    /// - Throws: CutiELinkError if configuration is missing or API fails
    @MainActor
    @discardableResult
    public static func openFeedbackApp() async throws -> Bool {
        try await shared.openFeedbackApp()
    }

    /// Check if the Cuti-E Feedback App is installed
    @MainActor
    public static var isFeedbackAppInstalled: Bool {
        guard let url = URL(string: "cutie://") else { return false }
        return UIApplication.shared.canOpenURL(url)
    }

    // MARK: - Private Implementation

    @MainActor
    private func openFeedbackApp() async throws -> Bool {
        guard let apiKey = apiKey else {
            throw CutiELinkError.notConfigured
        }

        // Generate device ID (persistent per app install)
        let deviceId = getDeviceId()

        // Request link token from API
        let token = try await generateToken(apiKey: apiKey, deviceId: deviceId)

        // Open deep link
        guard let deepLink = URL(string: "cutie://link?token=\(token)") else {
            throw CutiELinkError.invalidDeepLink
        }

        if UIApplication.shared.canOpenURL(deepLink) {
            await UIApplication.shared.open(deepLink)
            return true
        } else {
            // Feedback App not installed - open App Store
            if let appStoreURL = URL(string: "https://apps.apple.com/app/cuti-e-feedback/id0000000000") {
                await UIApplication.shared.open(appStoreURL)
            }
            return false
        }
    }

    private func generateToken(apiKey: String, deviceId: String) async throws -> String {
        guard let url = URL(string: "\(baseURL)/v1/feedback-app/generate-token") else {
            throw CutiELinkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "X-API-Key")

        var body: [String: Any] = ["device_id": deviceId]
        if let appId = appId {
            body["app_id"] = appId
        }

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw CutiELinkError.invalidResponse
        }

        if httpResponse.statusCode == 401 {
            throw CutiELinkError.invalidAPIKey
        }

        guard httpResponse.statusCode == 200 else {
            throw CutiELinkError.serverError(httpResponse.statusCode)
        }

        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let token = json["token"] as? String else {
            throw CutiELinkError.invalidResponse
        }

        return token
    }

    private func getDeviceId() -> String {
        let key = "com.cutie.link.deviceId"
        if let existing = UserDefaults.standard.string(forKey: key) {
            return existing
        }
        let newId = UUID().uuidString
        UserDefaults.standard.set(newId, forKey: key)
        return newId
    }
}

// MARK: - Errors

public enum CutiELinkError: LocalizedError {
    case notConfigured
    case invalidAPIKey
    case invalidURL
    case invalidDeepLink
    case invalidResponse
    case serverError(Int)
    case feedbackAppNotInstalled

    public var errorDescription: String? {
        switch self {
        case .notConfigured:
            return "CutiELink not configured. Call CutiELink.configure(apiKey:) first."
        case .invalidAPIKey:
            return "Invalid API key"
        case .invalidURL:
            return "Invalid API URL"
        case .invalidDeepLink:
            return "Failed to create deep link"
        case .invalidResponse:
            return "Invalid server response"
        case .serverError(let code):
            return "Server error: \(code)"
        case .feedbackAppNotInstalled:
            return "Cuti-E Feedback App is not installed"
        }
    }
}
