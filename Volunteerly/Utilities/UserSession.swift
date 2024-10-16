//
//  UserSession.swift
//  Volunteerly
//
//  Created by Rahul Ramachandran on 13/10/24.
//

import Foundation
import FirebaseAuth
import SwiftUI

class UserSession: ObservableObject {
    @Published var isLoggedIn: Bool = false
    private var userViewModel: UserViewModel
    private var eventsViewModel: EventsViewModel
    
    init(userViewModel: UserViewModel, eventsViewModel: EventsViewModel) {
        self.userViewModel = userViewModel
        self.eventsViewModel = eventsViewModel
        checkIfUserIsLoggedIn()
    }

    // Check if a user is already logged in and validate user status
    func checkIfUserIsLoggedIn(completion: @escaping () -> Void = {}) {
        if let user = Auth.auth().currentUser {
            // Check if the user still exists in FirebaseAuth
            user.reload { error in
                if error != nil {
                    // User does not exist or there was an error, log out the user
                    self.logoutUser()
                } else {
                            // User is valid and authenticated
                            self.isLoggedIn = true

                }
                completion() // Call completion handler to continue the app flow
            }
        } else {
            // No user is logged in
            isLoggedIn = false
            completion() // Call completion handler to continue the app flow
        }
    }

    // Handle user login
    func loginUser(email: String, password: String, completion: @escaping (String?) -> Void) {
        guard isValidEmail(email) else {
            completion("Please enter a valid email address.")
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(self.handleFirebaseAuthError(error))
            } else {
                        self.isLoggedIn = true
                completion(nil)
            }
        }
    }

    // Handle user logout
    func logoutUser() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
            
            // Clear user-specific data after logout
            userViewModel.clearUserData() // Clears preferences, booked events, etc.
            eventsViewModel.clearEventsData() // Clears events list
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }

    // Handle user creation with password validation
    func createUser(name: String, email: String, password: String, confirmPassword: String, completion: @escaping (String?) -> Void) {
        guard isValidEmail(email) else {
            completion("Please enter a valid email address.")
            return
        }
        
        guard password == confirmPassword else {
            completion("Passwords do not match.")
            return
        }

        guard isValidPassword(password) else {
            completion("Password must be at least 8 characters long.")
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(self.handleFirebaseAuthError(error))
            } else if let user = authResult?.user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = name
                changeRequest.commitChanges { error in
                    if let error = error {
                        completion("Failed to update profile: \(error.localizedDescription)")
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }

    // Handle password reset
    func resetPassword(email: String, completion: @escaping (String?) -> Void) {
        guard isValidEmail(email) else {
            completion("Please enter a valid email address.")
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(self.handleFirebaseAuthError(error))
            } else {
                completion(nil)
            }
        }
    }

    // Validate email format
    func isValidEmail(_ email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }

    // Validate password format
    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8
    }

    // Error handling for Firebase Authentication errors
    private func handleFirebaseAuthError(_ error: Error) -> String {
        let errorCode = AuthErrorCode(rawValue: error._code)
        switch errorCode {
        case .invalidEmail:
            return "Invalid email format. Please try again."
        case .wrongPassword:
            return "The password you entered is incorrect."
        case .userNotFound:
            return "No user found with this email."
        case .emailAlreadyInUse:
            return "This email is already in use."
        case .weakPassword:
            return "Your password is too weak. It should be at least 8 characters long."
        case .credentialAlreadyInUse:
            return "This credential is already in use. Please try logging in."
        case .invalidCredential, .userDisabled, .invalidUserToken:
            return "The supplied credentials are malformed or expired. Please try again."
        case .networkError:
            return "Network error. Please check your internet connection and try again."
        case .tooManyRequests:
            return "Too many requests. Please try again later."
        default:
            return "An error occurred: \(error.localizedDescription)"
        }
    }
}
