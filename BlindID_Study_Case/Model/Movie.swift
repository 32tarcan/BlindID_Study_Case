//
//  Movie.swift
//  BlindID_Study_Case
//
//  Created by Bahadır Tarcan on 21.05.2025.
//

import SwiftUI


struct Movie: Identifiable, Codable {
    let id: Int
    let title: String
    let year: Int
    let rating: Double
    let actors: [String]
    let category: String
    let posterURL: String
    let description: String
    
}
