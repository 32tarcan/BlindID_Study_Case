//
//  FavoritesViewModel.swift
//  BlindID_Study_Case
//
//  Created by Bahadır Tarcan on 21.05.2025.
//

import Foundation
import SwiftUI

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var likedMovies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func loadLikedMovies() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedMovies = try await MovieService.shared.getLikedMovies()
            likedMovies = fetchedMovies
        } catch MovieError.unauthorized {
            errorMessage = "Please log in to view your favorites"
        } catch MovieError.serverError(let message) {
            errorMessage = "Server error: \(message)"
        } catch {
            errorMessage = "Couldn't connect to server"
        }
        
        isLoading = false
    }
}
