//
//  RegisterView.swift
//  BlindID_Study_Case
//
//  Created by Bahadır Tarcan on 21.05.2025.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var name = ""
    @State private var surname = ""
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var navigateToMovies = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 32) {
                    Text("Sign Up")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    VStack(spacing: 20) {
                        TextField("Name", text: $name)
                            .textFieldStyle(.plain)
                            .textContentType(.givenName)
                            .autocapitalization(.words)
                            .padding()
                            .background(Color(.darkGray).opacity(0.3))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                        
                        TextField("Surname", text: $surname)
                            .textFieldStyle(.plain)
                            .textContentType(.familyName)
                            .autocapitalization(.words)
                            .padding()
                            .background(Color(.darkGray).opacity(0.3))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                        
                        TextField("E-mail", text: $email)
                            .textFieldStyle(.plain)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color(.darkGray).opacity(0.3))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                        
                        HStack {
                            if showPassword {
                                TextField("Password", text: $password)
                                    .textContentType(.newPassword)
                            } else {
                                SecureField("Password", text: $password)
                                    .textContentType(.newPassword)
                            }
                            
                            Button(action: {
                                showPassword.toggle()
                            }) {
                                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color(.darkGray).opacity(0.3))
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        
                        if let error = viewModel.error {
                            Text("Please check your information and try again.")
                                .foregroundColor(.red)
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 4)
                        }
                    }
                }
                .padding(.top, 50)
                
                Button(action: {
                    viewModel.register(name: name, surname: surname, email: email, password: password)
                }) {
                    ZStack {
                        Rectangle()
                            .fill(Color.red)
                            .cornerRadius(12)
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Sign up")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .disabled(viewModel.isLoading)
                
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.gray)
                    Button("Sign In") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
                .font(.footnote)
            }
            .padding(.horizontal, 24)
        }
        .navigationBarHidden(true)
        .onChange(of: viewModel.currentUser) { user in
            if user != nil {
                navigateToMovies = true
            }
        }
        .fullScreenCover(isPresented: $navigateToMovies) {
            MainTabView()
        }
    }
}

#Preview {
    NavigationStack {
        RegisterView()
    }
}
