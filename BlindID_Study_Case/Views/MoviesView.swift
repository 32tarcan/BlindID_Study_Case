//
//  MoviesView.swift
//  BlindID_Study_Case
//
//  Created by Bahadır Tarcan on 21.05.2025.
//

import SwiftUI

struct MoviesView: View {
    @State private var movies: [Movie] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack {
            if isLoading && movies.isEmpty {
                ProgressView()
                    .scaleEffect(1.5)
            } else if let errorMessage = errorMessage, movies.isEmpty {
                VStack(spacing: 16) {
                    Text("Error Loading Movies")
                        .font(.headline)
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    Button("Try Again") {
                        Task {
                            await loadMovies()
                        }
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 24) {
                        ForEach(movies) { movie in
                            MovieCardView(movie: movie)
                                .frame(height: 320)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 20)
                }
                .refreshable {
                    await loadMovies()
                }
            }
        }
        .navigationTitle("Movies")
        .onAppear {
            Task {
                await loadMovies()
            }
        }
    }
    
    private func loadMovies() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedMovies = try await MovieService.shared.getAllMovies()
            
            if fetchedMovies.isEmpty {
                errorMessage = "No movies found"
            } else {
                movies = fetchedMovies
                print("Loaded \(movies.count) movies")
            }
        } catch MovieError.unauthorized {
            errorMessage = "Please log in to view movies"
            print("Unauthorized error: Please log in to view movies")
        } catch MovieError.serverError(let message) {
            errorMessage = "Server error: \(message)"
            print("Server error: \(message)")
        } catch MovieError.decodingError(let message) {
            errorMessage = "Could not load movies data"
            print("Decoding error: \(message)")
        } catch {
            errorMessage = "Couldn't connect to server"
            print("Unknown error: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
}

#Preview {
    NavigationStack {
        MoviesView()
    }
}
