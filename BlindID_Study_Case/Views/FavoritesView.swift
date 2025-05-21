//
//  FavoritesView.swift
//  BlindID_Study_Case
//
//  Created by Bahadır Tarcan on 21.05.2025.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            if viewModel.isLoading && viewModel.likedMovies.isEmpty {
                ProgressView()
                    .scaleEffect(1.5)
            } else if let errorMessage = viewModel.errorMessage, viewModel.likedMovies.isEmpty {
                VStack(spacing: 16) {
                    Text("Error Loading Favorites")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    Button("Try Again") {
                        Task {
                            await viewModel.loadLikedMovies()
                        }
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
            } else if viewModel.likedMovies.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "heart.slash")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("No Favorite Movies")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Movies you like will appear here")
                        .foregroundColor(.gray)
                }
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 24) {
                        ForEach(viewModel.likedMovies) { movie in
                            MovieCardView(movie: movie, showLikeButton: false)
                                .frame(height: 320)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 20)
                }
                .refreshable {
                    await viewModel.loadLikedMovies()
                }
            }
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.black, for: .navigationBar)
        .onAppear {
            Task {
                await viewModel.loadLikedMovies()
            }
        }
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
    }
}
