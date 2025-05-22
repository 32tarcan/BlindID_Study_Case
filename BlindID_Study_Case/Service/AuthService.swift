//
//  AuthService.swift
//  BlindID_Study_Case
//
//  Created by Bahadır Tarcan on 21.05.2025.
//

import Foundation

class AuthService {
    static let shared = AuthService()
    private let apiService = APIRequestService.shared
    
    private init() {}
    
    func login(email: String, password: String) async throws -> User {
        let loginResponse: LoginResponse = try await apiService.request(
            endpoint: "/auth/login",
            method: .post,
            body: ["email": email, "password": password],
            requiresAuth: false
        )
        
        UserDefaults.standard.set(loginResponse.token, forKey: "authToken")
        return loginResponse.user
    }
    
    func register(name: String, surname: String, email: String, password: String) async throws -> User {
        let registerResponse: RegisterResponse = try await apiService.request(
            endpoint: "/auth/register",
            method: .post,
            body: [
                "name": name,
                "surname": surname,
                "email": email,
                "password": password
            ],
            requiresAuth: false
        )
        
        UserDefaults.standard.set(registerResponse.token, forKey: "authToken")
        return registerResponse.user
    }
    
    func getCurrentUser() async throws -> ProfileUser {
        return try await apiService.request(
            endpoint: "/auth/me",
            method: .get
        )
    }
    
    func updateProfile(name: String, surname: String) async throws -> ProfileUser {
        let updateResponse: UpdateProfileResponse = try await apiService.request(
            endpoint: "/users/profile",
            method: .put,
            body: ["name": name, "surname": surname]
        )
        
        // Convert User to ProfileUser
        return try await getCurrentUser()
    }
}
