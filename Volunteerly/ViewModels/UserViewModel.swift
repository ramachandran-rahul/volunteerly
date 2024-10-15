//
//  UserViewModel.swift
//  Volunteerly
//
//  Created by Rahul Ramachandran on 15/10/24.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class UserViewModel: ObservableObject {
    @Published var bookedEvents: [String] = []   // Array of booked event IDs
    @Published var preferences: [String] = []    // Array of preferences
    @Published var userName: String = ""
    @Published var email: String = ""

    private var userID: String?

    init() {
        // Check if the user is already logged in
        if let currentUser = FirebaseAuth.Auth.auth().currentUser {
            self.userID = currentUser.uid
            self.userName = currentUser.displayName ?? "No Name"
            self.email = currentUser.email ?? "No Email"
            fetchUserData {
                print("Data fetched successfully")
            }
        }
    }

    // Fetch user data from Firestore with completion handler
    func fetchUserData(completion: @escaping () -> Void) {
        guard let userID = self.userID else { return }

        let userRef = Firestore.firestore().collection("users").document(userID)

        userRef.getDocument { document, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }

            if let document = document, let data = document.data() {
                self.bookedEvents = data["bookedEvents"] as? [String] ?? []
                self.preferences = data["preferences"] as? [String] ?? []
            }
            completion()  // Call the completion handler after data fetch
        }
    }
    
    // Update preferences in Firestore with completion handler
    func updatePreferences(_ newPreferences: [String], completion: @escaping () -> Void) {
        guard let userID = self.userID else { return }

        let userRef = Firestore.firestore().collection("users").document(userID)
        userRef.updateData(["preferences": newPreferences]) { error in
            if let error = error {
                print("Error updating preferences: \(error.localizedDescription)")
            } else {
                // Update the local preferences after saving to Firestore
                self.preferences = newPreferences
                completion()  // Call the completion handler
            }
        }
    }
    
    // Update user's event booking status
    func updateEventBooking(eventID: String, shouldBook: Bool, completion: @escaping (Bool) -> Void) {
        guard let userID = self.userID else { return }

        let userRef = Firestore.firestore().collection("users").document(userID)
        
        let updateAction: FieldValue = shouldBook ? .arrayUnion([eventID]) : .arrayRemove([eventID])

        // Update the user's bookedEvents array based on shouldBook (add or remove)
        userRef.updateData([
            "bookedEvents": updateAction
        ]) { error in
            if let error = error {
                print("Error updating event booking: \(error.localizedDescription)")
                completion(false)
            } else {
                if shouldBook {
                    self.bookedEvents.append(eventID)
                } else {
                    self.bookedEvents.removeAll { $0 == eventID }
                }
                completion(true)
            }
        }
    }
}

