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
    let poster_url: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case year
        case rating
        case actors
        case category
        case poster_url
        case description
    }
}

struct MoviesResponse: Codable {
    let movies: [Movie]?
    
    let data: [Movie]?
    let results: [Movie]?
    let items: [Movie]?
    
    var allMovies: [Movie] {
        if let movies = movies {
            return movies
        } else if let data = data {
            return data
        } else if let results = results {
            return results
        } else if let items = items {
            return items
        } else {
            return []
        }
    }
}

struct MovieResponse: Codable {
    let movie: Movie?
    let data: Movie?
    
    var movieData: Movie {
        return movie ?? data ?? Movie(id: 0, title: "Unknown", year: 0, rating: 0, actors: [], category: "Unknown", poster_url: "", description: "No description available")
    }
}

enum MovieError: Error {
    case unauthorized
    case invalidResponse
    case serverError(message: String)
    case decodingError(message: String)
}
