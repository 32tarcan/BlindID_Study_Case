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
    init() {
        setupKeyboardManager()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .preferredColorScheme(.dark)
                .background(Color.black)
        }
    }
    
    private func setupKeyboardManager() {
        let keyboardManager = IQKeyboardManager.shared
        keyboardManager.isEnabled = true
        keyboardManager.resignOnTouchOutside = true
    }
}
