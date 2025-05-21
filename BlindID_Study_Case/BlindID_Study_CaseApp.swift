//
//  BlindID_Study_CaseApp.swift
//  BlindID_Study_Case
//
//  Created by Bahadır Tarcan on 21.05.2025.
//

import SwiftUI

@main
struct BlindID_Study_CaseApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView()
                .preferredColorScheme(.dark)
                .background(Color.black)
        }
    }
}
