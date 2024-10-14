//
//  LoginView.swift
//  Volunteerly
//
//  Created by Rahul Ramachandran on 12/10/24.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var loginErrorMessage: String?
    @State private var showCreateAccountSheet = false
    @State private var showResetPasswordSheet = false
    @ObservedObject var userSession: UserSession
    var loginViewModel: LoginViewModel
    
    var isFormValid: Bool {
        return userSession.isValidEmail(email) && !password.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(spacing: 5) {
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .customTextFieldStyle(iconName: "envelope")
                    .onChange(of: email) {
                        loginErrorMessage = nil // Clear error when email changes
                    }
                
                SecureField("Password", text: $password)
                    .customTextFieldStyle(iconName: "lock")
                    .onChange(of: password) {
                        loginErrorMessage = nil // Clear error when password changes
                    }
                
                if let loginErrorMessage = loginErrorMessage {
                    Text(loginErrorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                        .padding(.top, 2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            Button(action: {
                userSession.loginUser(email: email, password: password) { errorMessage in
                    if let errorMessage = errorMessage {
                        loginErrorMessage = errorMessage
                    } else {
                        // Setup user document after successful login
                        loginViewModel.setupUserDocument()
                    }
                }
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isFormValid ? Color.blue : Color.gray)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal)
            }
            .disabled(!isFormValid)
            
            Button(action: {
                showResetPasswordSheet = true
            }) {
                Text("Forgot your password?")
                    .font(.body)
                    .foregroundColor(.blue)
                    .underline()
                    .padding(.top)
            }
            .sheet(isPresented: $showResetPasswordSheet) {
                ResetPasswordView(userSession: userSession)
            }
            
            Button(action: {
                showCreateAccountSheet = true
            }) {
                Text("No account? Create one here.")
                    .font(.body)
                    .foregroundColor(.blue)
                    .underline()
            }
            .sheet(isPresented: $showCreateAccountSheet) {
                CreateAccountView(userSession: userSession)
            }
        }
        .padding()
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView(userSession: UserSession(), loginViewModel: LoginViewModel(contentViewModel: ContentViewModel(), eventsViewModel: EventsViewModel()))
        }
    }
}
