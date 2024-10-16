//
//  LoginViewModel.swift
//  Volunteerly
//
//  Created by Rahul Ramachandran on 15/10/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class LoginViewModel: ObservableObject {
    var contentViewModel: ContentViewModel
    var eventsViewModel: EventsViewModel
    
    init(contentViewModel: ContentViewModel, eventsViewModel: EventsViewModel) {
        self.contentViewModel = contentViewModel
        self.eventsViewModel = eventsViewModel
    }
    
    func setupUserDocument() {
        guard let userID = FirebaseAuth.Auth.auth().currentUser?.uid else { return }
        
        let userRef = Firestore.firestore().collection("users").document(userID)
        
        userRef.getDocument { document, error in
            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                print("User document already exists")
                // Now that user exists, load data
                self.contentViewModel.isDataLoaded = false  // Reset flag
                self.contentViewModel.loadDataForLoggedInUser(eventsViewModel: self.eventsViewModel) {
                    // Completion handler, handle as needed
                }
            } else {
                // Create the user document with default fields
                userRef.setData([
                    "bookedEvents": [],
                    "preferences": Constants.categories // Default categories for new users
                ]) { error in
                    if let error = error {
                        print("Error creating user document: \(error.localizedDescription)")
                    } else {
                        print("User document created with default preferences.")
                        // After creating the document, load the data
                        self.contentViewModel.isDataLoaded = false  // Reset flag
                        self.contentViewModel.loadDataForLoggedInUser(eventsViewModel: self.eventsViewModel) {
                            // Completion handler if needed
                        }
                    }
                }
            }
        }
    }
}
