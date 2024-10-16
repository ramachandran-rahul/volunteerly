//
//  ResetPasswordView.swift
//  Volunteerly
//
//  Created by Rahul Ramachandran on 13/10/24.
//

import SwiftUI
import FirebaseAuth

struct ResetPasswordView: View {
    @State private var email: String = ""
    @State private var errorMessage: String?
    @State private var successMessage: String?
    @ObservedObject var userSession: UserSession
    
    var isFormValid: Bool {
        return userSession.isValidEmail(email)
    }


    var body: some View {
        VStack(spacing: 30) {
            Text("Reset Password")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 5)

            VStack(spacing: 5) {
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .customTextFieldStyle(iconName: "envelope")

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                        .padding(.top, 2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                if let successMessage = successMessage {
                    HStack {
                        Image(systemName: "checkmark.circle")
                            .foregroundStyle(Color.green)
                            .font(.subheadline)
                        
                        Text(successMessage)
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }

            Button(action: {
                userSession.resetPassword(email: email) { errorMessage in
                    if let errorMessage = errorMessage {
                        self.errorMessage = errorMessage
                        self.successMessage = nil
                    } else {
                        self.successMessage = "A reset link has been sent to your email."
                        self.errorMessage = nil
                    }
                }
            }) {
                Text("Send Reset Link")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isFormValid ? Color.blue : Color.gray)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.top)
                    .padding(.horizontal)
            }
            .disabled(!isFormValid)
        }
        .padding()
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView(userSession: UserSession(userViewModel: UserViewModel(), eventsViewModel: EventsViewModel()))
    }
}
