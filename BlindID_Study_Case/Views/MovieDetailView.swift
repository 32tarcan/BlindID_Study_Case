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
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ZStack(alignment: .bottom) {
                        AsyncImage(url: URL(string: movie.poster_url)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .foregroundColor(.gray.opacity(0.3))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: UIScreen.main.bounds.height * 0.65)
                        .clipped()
                        
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .clear,
                                .clear,
                                .black.opacity(0.5),
                                .black.opacity(0.8),
                                .black
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(movie.title)
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(movie.category)
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                    .ignoresSafeArea(edges: [.top])
                    
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(spacing: 12) {
                            
                            InfoCard(
                                icon: "clock",
                                title: "Year",
                                value: "\(movie.year)"
                            )
                            
                            InfoCard(
                                icon: "star.fill",
                                title: "Rating",
                                value: String(format: "%.1f", movie.rating),
                                iconColor: .yellow
                            )
                            
                            Button(action: {
                                withAnimation(.interpolatingSpring(stiffness: 170, damping: 15)) {
                                    isLiked.toggle()
                                    animateHeart = 1.5
                                }
                                withAnimation(.easeInOut(duration: 0.1).delay(0.1)) {
                                    animateHeart = 1.0
                                }
                                
                                Task {
                                    do {
                                        if isLiked {
                                            try await MovieService.shared.likeMovie(id: movie.id)
                                        } else {
                                            try await MovieService.shared.unlikeMovie(id: movie.id)
                                        }
                                    } catch {
                                        print("Error toggling like status: \(error)")
                                        isLiked.toggle()
                                    }
                                }
                            }) {
                                InfoCard(
                                    icon: isLiked ? "heart.fill" : "heart",
                                    title: "Like",
                                    value: isLiked ? "Liked" : "Like",
                                    iconColor: isLiked ? .red : .white
                                )
                            }
                        }
                        .padding(.top, 20)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Story Plot")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(movie.description)
                                .font(.body)
                                .foregroundColor(.gray)
                                .lineSpacing(6)
                        }
                        
                        Divider()
                            .background(Color.gray.opacity(0.3))
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Cast")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            LazyHGrid(rows: [GridItem(.fixed(100))], spacing: 24) {
                                ForEach(movie.actors, id: \.self) { actor in
                                    VStack(spacing: 8) {
                                        Circle()
                                            .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                                            .frame(width: 70, height: 70)
                                            .overlay(
                                                Image(systemName: "person")
                                                    .font(.system(size: 24))
                                                    .foregroundColor(.gray)
                                            )
                                        
                                        let nameParts = actor.components(separatedBy: " ")
                                        
                                        Text(nameParts.first ?? "")
                                            .font(.system(size: 13))
                                            .foregroundColor(.white)
                                        
                                        if nameParts.count > 1 {
                                            Text(nameParts.dropFirst().joined(separator: " "))
                                                .font(.system(size: 13))
                                                .foregroundColor(.white)
                                                .lineLimit(1)
                                        }
                                    }
                                    .frame(width: 85)
                                }
                            }
                            .padding(.vertical, 10)
                        }
                        
                        Spacer()
                            .frame(height: 100)
                    }
                    .padding(.horizontal, 20)
                    .background(Color.black)
                }
            }
            .ignoresSafeArea(edges: [.top, .bottom])
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .task {
            do {
                isLiked = try await MovieService.shared.isMovieLiked(id: movie.id)
            } catch {
                print("Error checking like status: \(error)")
            }
        }
    }
}

struct InfoCard: View {
    let icon: String
    let title: String
    let value: String
    var iconColor: Color = .white
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(iconColor)
            
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(red: 0.15, green: 0.15, blue: 0.15))
        .cornerRadius(12)
    }
}
