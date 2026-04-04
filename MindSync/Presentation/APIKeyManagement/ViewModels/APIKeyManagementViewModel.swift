import Foundation
import Combine

@MainActor
final class APIKeyManagementViewModel: ObservableObject {

    enum Feedback: Equatable {
        case saved
        case error(String)
    }

    @Published var draftKey: String = ""
    @Published var isRevealed: Bool = false
    @Published var hasStoredKey: Bool = false
    @Published var feedback: Feedback? = nil
    @Published var isVerifying: Bool = false

    private let useCase: ManageAPIKeyUseCaseProtocol

    init(useCase: ManageAPIKeyUseCaseProtocol) {
        self.useCase = useCase
    }

    func loadKeyStatus() {
        hasStoredKey = useCase.hasKey()
    }

    func save() {
        Task {
            isVerifying = true
            feedback = nil
            do {
                try await useCase.saveKey(draftKey)
                hasStoredKey = true
                draftKey = ""
                isRevealed = false
                feedback = .saved
            } catch {
                feedback = .error(error.localizedDescription)
                logError("Save API key failed: \(error.localizedDescription)")
            }
            isVerifying = false
        }
    }

    func delete() {
        do {
            try useCase.deleteKey()
            hasStoredKey = false
            draftKey = ""
            isRevealed = false
            feedback = nil
        } catch {
            feedback = .error(error.localizedDescription)
            logError("Delete API key failed: \(error.localizedDescription)")
        }
    }

    func clearFeedback() {
        feedback = nil
    }

    func toggleReveal() {
        isRevealed.toggle()
    }
}
