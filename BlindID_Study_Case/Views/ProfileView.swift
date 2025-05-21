//
//  ProfileView.swift
//  BlindID_Study_Case
//
//  Created by Bahadır Tarcan on 21.05.2025.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var isEditing = false
    @State private var name = ""
    @State private var surname = ""
    @State private var email = ""
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    VStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                        
                        if !isEditing {
                            Text("\(viewModel.currentUser?.name ?? "Loading...") \(viewModel.currentUser?.surname ?? "")")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.top, 32)
                    
                    // Profile Info
                    VStack(spacing: 20) {
                        if isEditing {
                            // Edit Mode
                            TextField("Name", text: $name)
                                .textFieldStyle(.plain)
                                .padding()
                                .background(Color(.darkGray).opacity(0.3))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                            
                            TextField("Surname", text: $surname)
                                .textFieldStyle(.plain)
                                .padding()
                                .background(Color(.darkGray).opacity(0.3))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                            
                            TextField("Email", text: $email)
                                .textFieldStyle(.plain)
                                .disabled(true)
                                .padding()
                                .background(Color(.darkGray).opacity(0.1))
                                .cornerRadius(12)
                                .foregroundColor(.gray)
                            
                            if let error = viewModel.error {
                                Text(error)
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                            
                            Button(action: {
                                Task {
                                    await viewModel.updateProfile(name: name, surname: surname)
                                    isEditing = false
                                }
                            }) {
                                ZStack {
                                    Rectangle()
                                        .fill(Color.red)
                                        .cornerRadius(12)
                                    
                                    if viewModel.isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    } else {
                                        Text("Save Changes")
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .frame(height: 50)
                            .disabled(viewModel.isLoading)
                            
                        } else {
                            // View Mode
                            if let user = viewModel.currentUser {
                                ProfileInfoRow(title: "Name", value: user.name)
                                ProfileInfoRow(title: "Surname", value: user.surname)
                                ProfileInfoRow(title: "Email", value: user.email)
                            } else {
                                ProgressView()
                                    .padding()
                            }
                            
                            Button(action: {
                                name = viewModel.currentUser?.name ?? ""
                                surname = viewModel.currentUser?.surname ?? ""
                                email = viewModel.currentUser?.email ?? ""
                                isEditing = true
                            }) {
                                ZStack {
                                    Rectangle()
                                        .fill(Color.red)
                                        .cornerRadius(12)
                                    
                                    Text("Edit Profile")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(height: 50)
                            .disabled(viewModel.currentUser == nil)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.black, for: .navigationBar)
        .onAppear {
            Task {
                print("ProfileView appeared - Fetching user data")
                await viewModel.getCurrentUser()
            }
        }
    }
}

struct ProfileInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text(value)
                .font(.body)
                .foregroundColor(.white)
            
            Divider()
                .background(Color.gray.opacity(0.3))
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
