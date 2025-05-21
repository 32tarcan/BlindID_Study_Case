//
//  LoginView.swift
//  BlindID_Study_Case
//
//  Created by Bahadır Tarcan on 21.05.2025.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var navigateToMovies = false
    @State private var showRegister = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 32) {
                        Text("Sign In")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        VStack(spacing: 20) {
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
                                        .textContentType(.password)
                                } else {
                                    SecureField("Password", text: $password)
                                        .textContentType(.password)
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
                            
                            Button(action: {
                                // Forgot password action
                            }) {
                                Text("Forgot password?")
                                    .foregroundColor(.gray)
                                    .font(.footnote)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    .padding(.top, 150)
                    
                    Button(action: {
                        navigateToMovies = true
                    }) {
                        Text("Sign in")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.top, 16)
                    
                    Spacer()
                    
                    HStack {
                        Text("Don't you have an account?")
                            .foregroundColor(.gray)
                        Button("Sign Up") {
                            showRegister = true
                        }
                        .foregroundColor(.white)
                    }
                    .font(.footnote)
                }
                .padding(.horizontal, 24)
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $navigateToMovies) {
                MoviesView()
            }
            .navigationDestination(isPresented: $showRegister) {
                RegisterView()
            }
        }
    }
}

#Preview {
    LoginView()
}
