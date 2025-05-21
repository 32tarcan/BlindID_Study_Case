//
//  AuthService.swift
//  BlindID_Study_Case
//
//  Created by Bahadır Tarcan on 21.05.2025.
//

import Foundation

class AuthService {
    static let shared = AuthService()
    private let baseUrl = "https://moviatask.cerasus.app/api/auth"
    
    private init() {}
    
    func login(email: String, password: String) async throws -> User {
        let url = URL(string: "\(baseUrl)/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["email": email, "password": password]
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.invalidResponse
        }
        
        print("Login Response Status Code: \(httpResponse.statusCode)")
        print("Login Response Data: \(String(data: data, encoding: .utf8) ?? "")")
        
        if httpResponse.statusCode == 200 {
            let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
            UserDefaults.standard.set(loginResponse.token, forKey: "authToken")
            return loginResponse.user
        } else {
            do {
                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                throw AuthError.serverError(message: errorResponse.message)
            } catch {
                throw AuthError.serverError(message: "Login failed with status code: \(httpResponse.statusCode)")
            }
        }
    }
    
    func register(name: String, surname: String, email: String, password: String) async throws -> User {
        let url = URL(string: "\(baseUrl)/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = [
            "name": name,
            "surname": surname,
            "email": email,
            "password": password
        ]
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.invalidResponse
        }
        
        print("Register Response Status Code: \(httpResponse.statusCode)")
        print("Register Response Data: \(String(data: data, encoding: .utf8) ?? "")")
        
        if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
            let registerResponse = try JSONDecoder().decode(RegisterResponse.self, from: data)
            UserDefaults.standard.set(registerResponse.token, forKey: "authToken")
            return registerResponse.user
        } else {
            do {
                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                throw AuthError.serverError(message: errorResponse.message)
            } catch {
                throw AuthError.serverError(message: "Registration failed with status code: \(httpResponse.statusCode)")
            }
        }
    }
    
    func getCurrentUser() async throws -> User {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            throw AuthError.unauthorized
        }
        
        let url = URL(string: "\(baseUrl)/me")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.invalidResponse
        }
        
        print("Get Current User Response Status Code: \(httpResponse.statusCode)")
        print("Get Current User Response Data: \(String(data: data, encoding: .utf8) ?? "")")
        
        if httpResponse.statusCode == 200 {
            return try JSONDecoder().decode(User.self, from: data)
        } else {
            throw AuthError.unauthorized
        }
    }
}
