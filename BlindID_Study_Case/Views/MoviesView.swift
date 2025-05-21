//
//  MoviesView.swift
//  BlindID_Study_Case
//
//  Created by Bahadır Tarcan on 21.05.2025.
//

import SwiftUI

struct MoviesView: View {
    
    let movies = Movie.sampleMovies
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
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
            .navigationTitle("Movies")
        }
    }
}

#Preview {
    MoviesView()
}
