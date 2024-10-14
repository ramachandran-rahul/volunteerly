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
    @State private var isDataLoaded = false
    @StateObject var userSession = UserSession()
    @StateObject var eventsViewModel = EventsViewModel()
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.88, green: 0.96, blue: 0.98), Color(red: 0.88, green: 0.96, blue: 0.91)]), // light teal to light green
                           startPoint: .top,
                           endPoint: .bottom)
            .ignoresSafeArea()
            if isLoading || !isDataLoaded {
                SplashScreenView(isLoading: $isLoading)
            } else { // Redirects to the relevant view after delay
                VStack {
                    if userSession.isLoggedIn {
                        // Show the main app content
                        MainTabView(userSession: userSession)
                            .environmentObject(eventsViewModel)
                    } else {
                        // Show the login screen
                        LoginView(userSession: userSession)
                    }
                }
            }
        }
        .onAppear {
            // Fetch events when the app loads
            eventsViewModel.fetchEvents {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isDataLoaded = true // Mark data as loaded after 1 second
                    // Delay splash screen for 2 seconds after data is loaded
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isLoading = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
