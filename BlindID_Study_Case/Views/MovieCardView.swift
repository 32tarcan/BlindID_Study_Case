//
//  MoviewCardView.swift
//  BlindID_Study_Case
//
//  Created by Bahadır Tarcan on 21.05.2025.
//


import SwiftUI

struct MovieCardView: View {
    let movie: Movie
    @State private var isLiked = false
    @State private var animateHeart = 1.0
    
    var body: some View {
        NavigationLink(destination: MovieDetailView()) {
            VStack(alignment: .leading, spacing: 8) {
                // Image with Like Button
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: URL(string: movie.posterURL)) { image in
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
                    Button(action: {
                        withAnimation(.interpolatingSpring(stiffness: 170, damping: 15)) {
                            isLiked.toggle()
                            animateHeart = 1.5
                        }
                        withAnimation(.easeInOut(duration: 0.1).delay(0.1)) {
                            animateHeart = 1.0
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
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(movie.title)
                        .font(.headline)
                        .lineLimit(1)
                        .foregroundColor(.primary)
                    
                    Text("movie.overview")
                        .font(.subheadline)
                        .lineLimit(2)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 4)
        }
    }
}

#Preview {
    MovieCardView(movie: Movie.sampleMovie)
        .padding()
} 

extension Movie {
    static let sampleMovies = [
        Movie(
            id: 1,
            title: "Inception",
            year: 2010,
            rating: 8.8,
            actors: ["Leonardo DiCaprio", "Joseph Gordon-Levitt", "Elliot Page"],
            category: "Science Fiction",
            posterURL: "https://m.media-amazon.com/images/M/MV5BMjAxM2Y3NjYtNF5BM15BanBnXkFtZTcwNTI5OTM0Mw@@._V1_FMjpg_UX1000_.JPG",
            description: "A skilled thief is offered a chance to erase his criminal history by planting an idea into a target's subconscious."
        ),
        Movie(
            id: 2,
            title: "The Flash",
            year: 2023,
            rating: 7.0,
            actors: ["Ezra Miller", "Michael Keaton", "Sasha Calle"],
            category: "Action",
            posterURL: "https://m.media-amazon.com/images/M/MV5BZWE2ZWE5MDQtMTJlZi00MTVjLTkxOTgtNmNiYjg2NDIxN2NhXkEyXkFqcGdeQXVyMTUzMTg2ODkz._V1_.jpg",
            description: "Barry Allen uses his super speed to change the past, but his attempt to save his family creates a world without super heroes."
        ),
        Movie(
            id: 3,
            title: "Aquaman and the Lost Kingdom",
            year: 2023,
            rating: 6.7,
            actors: ["Jason Momoa", "Patrick Wilson", "Amber Heard"],
            category: "Action",
            posterURL: "https://m.media-amazon.com/images/M/MV5BMTkxM2FiYjctYjliYy00NjY2LWFmOTEtYWZiYjNiODY1YzUxXkEyXkFqcGdeQXVyMTUzMTg2ODkz._V1_.jpg",
            description: "Aquaman balances his duties as king and as a member of the Justice League."
        ),
        Movie(
            id: 4,
            title: "Salaar: Part 1 - Ceasefire",
            year: 2023,
            rating: 7.2,
            actors: ["Prabhas", "Prithviraj Sukumaran", "Shruti Haasan"],
            category: "Action",
            posterURL: "https://m.media-amazon.com/images/M/MV5BZjYzMWE5YTctODFlMC00OTg4LWIzYmEtNTJmZmQ0ODBkNjc3XkEyXkFqcGdeQXVyMTUzNTgzNzM0._V1_.jpg",
            description: "A gang leader tries to keep a promise made to his dying friend and takes on the other criminal gangs."
        ),
        Movie(
            id: 5,
            title: "Oppenheimer",
            year: 2023,
            rating: 8.9,
            actors: ["Cillian Murphy", "Emily Blunt", "Robert Downey Jr."],
            category: "Biography",
            posterURL: "https://m.media-amazon.com/images/M/MV5BMDBmYTZjNjUtN2M1MS00MTQ2LTk2ODgtNzc2M2QyZGE5NTVjXkEyXkFqcGdeQXVyNzAwMjU2MTY@._V1_.jpg",
            description: "The story of American scientist J. Robert Oppenheimer and his role in the development of the atomic bomb."
        ),
        Movie(
            id: 6,
            title: "Barbie",
            year: 2023,
            rating: 7.0,
            actors: ["Margot Robbie", "Ryan Gosling", "Will Ferrell"],
            category: "Comedy",
            posterURL: "https://m.media-amazon.com/images/M/MV5BNjU3N2QxNzYtMjk1NC00MTc4LTk1NTQtMmUxNTljM2I0NDA5XkEyXkFqcGdeQXVyODE5NzE3OTE@._V1_.jpg",
            description: "Barbie suffers a crisis that leads her to question her world and her existence."
        )
    ]
    
    static let sampleMovie = sampleMovies[0]
} 
