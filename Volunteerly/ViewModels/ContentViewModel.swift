//
//  ContentViewModel.swift
//  Volunteerly
//
//  Created by Rahul Ramachandran on 15/10/24.
//

import SwiftUI
import FirebaseAuth

class ContentViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var isDataLoaded = false
    @Published var showSplashScreen = true

    // Function to handle splash screen delay for logged-out users
    func showSplashScreenForLoggedOutUser() {
        // Splash screen delay for 2 seconds before going to login view
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
            self.showSplashScreen = false
        }
    }

    // Function to load data for logged-in users
    func loadDataForLoggedInUser(eventsViewModel: EventsViewModel, completion: @escaping () -> Void) {
        // Fetch events and user data for a logged-in user
        eventsViewModel.fetchEvents {
            DispatchQueue.main.async {
                self.isDataLoaded = true
                // Delay splash screen for 2 more seconds before transitioning
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isLoading = false
                    self.showSplashScreen = false
                    completion()
                }
            }
        }
    }
}
