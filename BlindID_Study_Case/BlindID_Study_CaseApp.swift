//
//  BlindID_Study_CaseApp.swift
//  BlindID_Study_Case
//
//  Created by Bahadır Tarcan on 21.05.2025.
//

import SwiftUI
import IQKeyboardManagerSwift

@main
struct BlindID_Study_CaseApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    init() {
        setupKeyboardManager()
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authViewModel.isCheckingAuth {
                    SplashView()
                } else if authViewModel.currentUser != nil {
                    MainTabView()
                } else {
                    LoginView()
                }
            }
            .preferredColorScheme(.dark)
            .background(Color.black)
            .task {
                // Add a small delay to show the splash screen
                try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
                await authViewModel.checkAuthStatus()
            }
            .environmentObject(authViewModel)
        }
    }
    
    private func setupKeyboardManager() {
        let keyboardManager = IQKeyboardManager.shared
        keyboardManager.isEnabled = true
        keyboardManager.resignOnTouchOutside = true
    }
}
