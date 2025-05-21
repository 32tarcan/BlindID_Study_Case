//
//  AuthModel.swift
//  BlindID_Study_Case
//
//  Created by Bahadır Tarcan on 21.05.2025.
//

import Foundation


struct User: Codable, Equatable {
    let id: String
    let name: String
    let surname: String
    let email: String
}

struct ProfileUser: Codable, Equatable {
    let id: String
    let name: String
    let surname: String
    let email: String
    let likedMovies: [Int]
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case surname
        case email
        case likedMovies
        case createdAt
        case updatedAt
    }
}

struct UpdateProfileResponse: Codable {
    let message: String
    let user: User
}

struct LoginResponse: Codable {
    let message: String
    let token: String
    let user: User
}

struct RegisterResponse: Codable {
    let message: String
    let token: String
    let user: User
}

struct ErrorResponse: Codable {
    let message: String
}

enum AuthError: Error {
    case invalidResponse
    case unauthorized
    case serverError(message: String)
}
