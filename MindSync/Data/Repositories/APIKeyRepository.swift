import Foundation

final class APIKeyRepository: APIKeyRepositoryProtocol {

    private let keychainManager: KeychainManagerProtocol

    init(keychainManager: KeychainManagerProtocol) {
        self.keychainManager = keychainManager
    }

    func saveKey(_ key: String) throws {
        try keychainManager.save(key, for: AppConstants.Keychain.openRouterKeyAccount)
    }

    func getKey() throws -> String {
        do {
            return try keychainManager.retrieve(for: AppConstants.Keychain.openRouterKeyAccount)
        } catch AppError.keychainFailed(operation: "not-found") {
            throw AppError.missingAPIKey(provider: "OpenRouter")
        }
    }

    func deleteKey() throws {
        try keychainManager.delete(for: AppConstants.Keychain.openRouterKeyAccount)
    }

    func hasKey() -> Bool {
        (try? keychainManager.retrieve(for: AppConstants.Keychain.openRouterKeyAccount)) != nil
    }
}
