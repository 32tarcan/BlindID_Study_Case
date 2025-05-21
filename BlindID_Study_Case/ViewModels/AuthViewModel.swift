import SwiftUI
import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    @Published private(set) var currentUser: User?
    @Published private(set) var isLoading = false
    @Published private(set) var error: String?
    
    private let authService = AuthService.shared
    
    func login(email: String, password: String) {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                self.isLoading = true
                self.error = nil
                self.currentUser = try await authService.login(email: email, password: password)
            } catch AuthError.serverError(let message) {
                self.error = message
            } catch {
                self.error = "An unexpected error occurred"
            }
            self.isLoading = false
        }
    }
    
    func register(name: String, surname: String, email: String, password: String) {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                self.isLoading = true
                self.error = nil
                self.currentUser = try await authService.register(name: name, surname: surname, email: email, password: password)
            } catch AuthError.serverError(let message) {
                self.error = message
            } catch {
                self.error = "An unexpected error occurred"
            }
            self.isLoading = false
        }
    }
    
    func getCurrentUser() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                self.currentUser = try await authService.getCurrentUser()
            } catch {
                self.currentUser = nil
            }
        }
    }
    
    var isAuthenticated: Bool {
        UserDefaults.standard.string(forKey: "authToken") != nil
    }
} 
