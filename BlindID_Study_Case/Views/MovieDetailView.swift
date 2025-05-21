//
//  MovieDetailView.swift
//  BlindID_Study_Case
//
//  Created by Bahadır Tarcan on 21.05.2025.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @State private var isLiked = false
    @State private var animateHeart = 1.0
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                // Movie Poster with Like Button
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: URL(string: movie.poster_url)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Rectangle()
                            .foregroundColor(.gray.opacity(0.3))
                            .aspectRatio(2/3, contentMode: .fit)
                            .overlay(
                                ProgressView()
                            )
                    }
                    .cornerRadius(12)
                    
                    // Like Button
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
                            .font(.title)
                            .foregroundColor(isLiked ? .red : .white)
                            .scaleEffect(animateHeart)
                            .padding(12)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    .padding(16)
                }
                
                // Movie Title and Year
                VStack(alignment: .leading, spacing: 8) {
                    Text(movie.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    HStack {
                        Text("\(movie.year)")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", movie.rating))
                                .font(.headline)
                        }
                    }
                }
                
                // Category
                Text(movie.category)
                    .font(.subheadline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                // Description
                VStack(alignment: .leading, spacing: 8) {
                    Text("Overview")
                        .font(.headline)
                    
                    Text(movie.description)
                        .font(.body)
                        .lineSpacing(4)
                }
                
                // Actors
                VStack(alignment: .leading, spacing: 8) {
                    Text("Cast")
                        .font(.headline)
                    
                    ForEach(movie.actors, id: \.self) { actor in
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(.secondary)
                            Text(actor)
                                .font(.body)
                        }
                        .padding(.vertical, 2)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Movie Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            // Check if the movie is liked immediately when the view is created
            do {
                isLiked = try await MovieService.shared.isMovieLiked(id: movie.id)
            } catch {
                print("Error checking like status: \(error)")
            }
        }
    }
}

#Preview {
    NavigationStack {
        MovieDetailView(movie: Movie(
            id: 1,
            title: "Inception",
            year: 2010,
            rating: 8.8,
            actors: ["Leonardo DiCaprio", "Joseph Gordon-Levitt", "Elliot Page"],
            category: "Science Fiction",
            poster_url: "https://m.media-amazon.com/images/M/MV5BMjAxM2Y3NjYtNF5BM15BanBnXkFtZTcwNTI5OTM0Mw@@._V1_FMjpg_UX1000_.JPG",
            description: "A thief who steals corporate secrets through dream-sharing technology is given the task of planting an idea into the mind of a CEO."
        ))
    }
}
