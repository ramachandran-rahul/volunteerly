//
//  CreateAccountView.swift
//  Volunteerly
//
//  Created by Rahul Ramachandran on 12/10/24.
//

import SwiftUI
import FirebaseAuth

struct CreateAccountView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String?
    
    // State to hold individual field validation messages
    @State private var nameErrorMessage: String?
    @State private var emailErrorMessage: String?
    @State private var passwordErrorMessage: String?
    @State private var confirmPasswordErrorMessage: String?
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userSession: UserSession

    // Real-time form validation
    var isFormValid: Bool {
        return nameErrorMessage == nil &&
               emailErrorMessage == nil &&
               passwordErrorMessage == nil &&
               confirmPasswordErrorMessage == nil &&
               !name.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty
    }

    var body: some View {
        VStack(spacing: 50) {
            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(spacing: 10) {
                // Name Field
                VStack(alignment: .leading, spacing: 5) {
                    TextField("Name", text: $name)
                        .customTextFieldStyle(iconName: "person")
                        .onChange(of: name) { validateName() }
                    
                    Text(nameErrorMessage ?? " ")
                        .font(.caption)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                }

                // Email Field
                VStack(alignment: .leading, spacing: 5) {
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                        .customTextFieldStyle(iconName: "envelope")
                        .onChange(of: email) { validateEmail() }
                    
                    Text(emailErrorMessage ?? " ")
                        .font(.caption)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                }

                // Password Field
                VStack(alignment: .leading, spacing: 5) {
                    SecureField("Password", text: $password)
                        .customTextFieldStyle(iconName: "lock")
                        .onChange(of: password) { validatePassword() }
                    
                    Text(passwordErrorMessage ?? " ")
                        .font(.caption)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                }

                // Confirm Password Field
                VStack(alignment: .leading, spacing: 5) {
                    SecureField("Confirm Password", text: $confirmPassword)
                        .customTextFieldStyle(iconName: "lock")
                        .onChange(of: confirmPassword) { validateConfirmPassword() }
                    
                    Text(confirmPasswordErrorMessage ?? " ")
                        .font(.caption)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                }

                // General Error Message for Firebase Issues
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                        .padding(.top, 2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            // Submit Button
            Button(action: {
                userSession.createUser(name: name, email: email, password: password, confirmPassword: confirmPassword) { errorMessage in
                    if let errorMessage = errorMessage {
                        self.errorMessage = errorMessage
                    } else {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }) {
                Text("Submit")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isFormValid ? Color.blue : Color.gray)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal)
            }
            .disabled(!isFormValid)  // Disable if form is not valid
        }
        .padding()
    }
    
    // MARK: - Validation Functions
    
    private func validateName() {
        nameErrorMessage = name.isEmpty ? "Name cannot be empty." : nil
    }

    private func validateEmail() {
        if email.isEmpty {
            emailErrorMessage = "Email cannot be empty."
        } else if !userSession.isValidEmail(email) {
            emailErrorMessage = "Please enter a valid email address."
        } else {
            emailErrorMessage = nil
        }
    }

    private func validatePassword() {
        if password.isEmpty {
            passwordErrorMessage = "Password cannot be empty."
        } else if !userSession.isValidPassword(password) {
            passwordErrorMessage = "Password must be at least 8 characters."
        } else {
            passwordErrorMessage = nil
        }
    }

    private func validateConfirmPassword() {
        if confirmPassword.isEmpty {
            confirmPasswordErrorMessage = "Please confirm your password."
        } else if password != confirmPassword {
            confirmPasswordErrorMessage = "Passwords do not match."
        } else {
            confirmPasswordErrorMessage = nil
        }
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView(userSession: UserSession())
    }
}
