import Foundation

protocol APIKeyRepositoryProtocol {
    func saveKey(_ key: String) throws
    func getKey() throws -> String
    func deleteKey() throws
    func hasKey() -> Bool
}
