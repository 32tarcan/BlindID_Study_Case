import SwiftUI
import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var profileUser: ProfileUser?
    @Published var isLoading = false
    @Published var isCheckingAuth = true
    @Published var error: String?
    
    private let authService = AuthService.shared
    
    func checkAuthStatus() async {
        isCheckingAuth = true
        if isAuthenticated {
            await getCurrentUser()
        }
        isCheckingAuth = false
    }
    
    func getCurrentUser() async {
        print("Getting current user...")
        isLoading = true
        error = nil
        
        do {
            let profile = try await AuthService.shared.getCurrentUser()
            print("Current user fetched successfully: \(profile)")
            profileUser = profile
            // Update currentUser from profile data
            currentUser = User(id: profile.id, name: profile.name, surname: profile.surname, email: profile.email)
        } catch {
            print("Error fetching current user: \(error)")
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func login(email: String, password: String) async {
        print("Attempting login...")
        isLoading = true
        error = nil
        
        do {
            let user = try await AuthService.shared.login(email: email, password: password)
            print("Login successful: \(user)")
            currentUser = user
            // Fetch profile data after successful login
            await getCurrentUser()
        } catch {
            print("Login error: \(error)")
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func register(name: String, surname: String, email: String, password: String) async {
        print("Attempting registration...")
        isLoading = true
        error = nil
        
        do {
            let user = try await AuthService.shared.register(name: name, surname: surname, email: email, password: password)
            print("Registration successful: \(user)")
            currentUser = user
            // Fetch profile data after successful registration
            await getCurrentUser()
        } catch {
            print("Registration error: \(error)")
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func updateProfile(name: String, surname: String) async {
        print("Updating profile...")
        isLoading = true
        error = nil
        
        do {
            let profile = try await AuthService.shared.updateProfile(name: name, surname: surname)
            print("Profile update successful: \(profile)")
            profileUser = profile
            currentUser = User(id: profile.id, name: profile.name, surname: profile.surname, email: profile.email)
        } catch {
            print("Profile update error: \(error)")
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
    
    var isAuthenticated: Bool {
        UserDefaults.standard.string(forKey: "authToken") != nil
    }
} 
