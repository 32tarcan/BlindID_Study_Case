//
//  MainTabView.swift
//  BlindID_Study_Case
//
//  Created by Bahadır Tarcan on 21.05.2025.
//


import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                MoviesView()
            }
            .tabItem {
                Image(systemName: "film")
                Text("Movies")
            }
            
            NavigationStack {
                FavoritesView()
            }
            .tabItem {
                Image(systemName: "heart.fill")
                Text("Favorites")
            }
            
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
        }
        .preferredColorScheme(.dark)
        .background(Color.black)
        .tint(.red)
        
    }
}
#Preview {
    MainTabView()
}
