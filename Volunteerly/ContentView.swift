//
//  ContentView.swift
//  Volunteerly
//
//  Created by Rahul Ramachandran on 11/10/24.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var isLoading = true
    @StateObject var userSession = UserSession()
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.88, green: 0.96, blue: 0.98), Color(red: 0.88, green: 0.96, blue: 0.91)]), // light teal to light green
                           startPoint: .top,
                           endPoint: .bottom)
            .ignoresSafeArea()
            if isLoading {
                SplashScreenView(isLoading: $isLoading)
            } else { // Redirects to the relevant view after delay
                VStack {
                    if userSession.isLoggedIn {
                        // Show the main app content
                        MainTabView(userSession: userSession)
                    } else {
                        // Show the login screen
                        LoginView(userSession: userSession)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
