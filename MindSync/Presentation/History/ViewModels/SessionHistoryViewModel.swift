import Foundation

@MainActor
final class SessionHistoryViewModel: ObservableObject {

    @Published private(set) var sessions: [ChatSession] = []
    @Published private(set) var isLoading: Bool = false

    private let sessionRepository: ChatSessionRepositoryProtocol

    init(sessionRepository: ChatSessionRepositoryProtocol) {
        self.sessionRepository = sessionRepository
    }

    func loadSessions() async {
        isLoading = true
        defer { isLoading = false }
        do {
            sessions = try await sessionRepository.loadAll()
        } catch {
            logError("SessionHistory load failed: \(error.localizedDescription)")
        }
    }

    func delete(id: UUID) async {
        do {
            try await sessionRepository.delete(id: id)
            sessions.removeAll { $0.id == id }
        } catch {
            logError("SessionHistory delete failed: \(error.localizedDescription)")
        }
    }
}
