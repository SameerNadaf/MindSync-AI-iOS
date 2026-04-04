import Foundation

protocol ChatSessionRepositoryProtocol: Sendable {
    func save(_ session: ChatSession) async throws
    func loadAll() async throws -> [ChatSession]
    func delete(id: UUID) async throws
}
