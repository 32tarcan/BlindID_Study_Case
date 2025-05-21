//
//  MoviewCardView.swift
//  BlindID_Study_Case
//
//  Created by Bahadır Tarcan on 21.05.2025.
//


import SwiftUI

struct MovieCardView: View {
    let movie: Movie
    let showLikeButton: Bool
    @State private var isLiked = false
    @State private var animateHeart = 1.0
    
    init(movie: Movie, showLikeButton: Bool = true) {
        self.movie = movie
        self.showLikeButton = showLikeButton
    }
    
    var body: some View {
        NavigationLink {
            MovieDetailView(movie: movie)
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                // Image with Like Button
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: URL(string: movie.poster_url)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .foregroundColor(.gray.opacity(0.3))
                            .overlay(
                                ProgressView()
                            )
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 240)
                    .cornerRadius(10)
                    .clipped()
                    
                    // Like Button
                    if showLikeButton {
                        Button(action: {
                            withAnimation(.interpolatingSpring(stiffness: 170, damping: 15)) {
                                isLiked.toggle()
                                animateHeart = 1.5
                            }
                            withAnimation(.easeInOut(duration: 0.1).delay(0.1)) {
                                animateHeart = 1.0
                            }
                            
                            // Call API to like/unlike movie
                            Task {
                                do {
                                    if isLiked {
                                        try await MovieService.shared.likeMovie(id: movie.id)
                                    } else {
                                        try await MovieService.shared.unlikeMovie(id: movie.id)
                                    }
                                } catch {
                                    print("Error toggling like status: \(error)")
                                    // Revert the like state if the API call fails
                                    isLiked.toggle()
                                }
                            }
                        }) {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .font(.title2)
                                .foregroundColor(isLiked ? .red : .white)
                                .scaleEffect(animateHeart)
                                .padding(8)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                        .padding(8)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(movie.title)
                        .font(.headline)
                        .lineLimit(1)
                        .foregroundColor(.white)
                    
                    Text(movie.description)
                        .font(.subheadline)
                        .lineLimit(2)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.12, green: 0.12, blue: 0.12))
                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
            )
        }
        .onAppear {
            // Check if the movie is liked when the view appears
            if showLikeButton {
                Task {
                    do {
                        isLiked = try await MovieService.shared.isMovieLiked(id: movie.id)
                    } catch {
                        print("Error checking like status: \(error)")
                    }
                }
            }
        }
    }
} 
