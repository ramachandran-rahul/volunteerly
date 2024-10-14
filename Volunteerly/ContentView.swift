//
//  ContentView.swift
//  Volunteerly
//
//  Created by Rahul Ramachandran on 11/10/24.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject var contentViewModel = ContentViewModel()
    @StateObject var userSession = UserSession()
    @StateObject var eventsViewModel = EventsViewModel()
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.88, green: 0.96, blue: 0.98), Color(red: 0.88, green: 0.96, blue: 0.91)]), // light teal to light green
                           startPoint: .top,
                           endPoint: .bottom)
            .ignoresSafeArea()
            
            if contentViewModel.showSplashScreen {
                SplashScreenView(isLoading: $contentViewModel.isLoading)
            } else {
                if userSession.isLoggedIn && contentViewModel.isDataLoaded {
                    // Show the main app content
                    MainTabView(userSession: userSession)
                        .environmentObject(eventsViewModel)
                } else {
                    // Show the login screen
                    LoginView(userSession: userSession, loginViewModel: LoginViewModel(contentViewModel: contentViewModel, eventsViewModel: eventsViewModel))
                }
            }
        }
        .onAppear {
            // Check if the user is still authenticated
            userSession.checkIfUserIsLoggedIn {
                if userSession.isLoggedIn {
                    // If the user is logged in, load events and user data
                    contentViewModel.loadDataForLoggedInUser(eventsViewModel: eventsViewModel) {
                        // Completion handler for future extensibility
                    }
                } else {
                    // If the user is not logged in, show splash screen for 2 seconds then go to login
                    contentViewModel.showSplashScreenForLoggedOutUser()
                }
            }
        }
        
    }
}

#Preview {
    ContentView()
}
