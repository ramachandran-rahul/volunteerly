//
//  ProfileView.swift
//  Volunteerly
//
//  Created by Rahul Ramachandran on 14/10/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @ObservedObject var userSession: UserSession
    
    var body: some View {
        VStack {
            // Static Profile Header Section
            VStack {
                Text("Profile")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 10) {
                    // User Details Section
                    Text("\(FirebaseAuth.Auth.auth().currentUser?.displayName ?? "No Name")").font(.title2).fontWeight(.semibold)
                    Text("\(FirebaseAuth.Auth.auth().currentUser?.email ?? "No Email")").font(.title3).fontWeight(.semibold)
                    Text("User Preferences:").font(.title3).fontWeight(.semibold)
                    CategoryPillView(text: "Environmental")
                    
                    // Center-aligned Logout Button
                    HStack {
                        Spacer() // Pushes the content to the center
                        HStack {
                            Image(systemName: "ipad.and.arrow.forward")
                                .foregroundColor(.red)
                            Text("Logout")
                                .foregroundColor(.red)
                        }
                        .padding(8)
                        .padding(.horizontal)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.red, lineWidth: 1)
                        )
                        Spacer()
                    }
                    .padding(.top, 5)
                }
                .padding(.top, 5)
                .padding(.horizontal)
                .padding(.bottom, 5)

            }
            .padding(.bottom)
            
            // Scrollable Events Section
            ScrollView {
                VStack(alignment: .leading) {
                    Text("\(FirebaseAuth.Auth.auth().currentUser?.displayName ?? "No Name")'s Events")
                        .font(.title2)
                        .bold()
                        .padding(.leading, 16)
                    
                    // Dummy event tiles
                    VStack(spacing: 16) {
                        ForEach(0..<5) { _ in
                            EventTileView()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 1)
                }
                .padding(.vertical)
                .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.78, green: 0.86, blue: 0.88), Color(red: 0.78, green: 0.86, blue: 0.81)]),
                                           startPoint: .top, endPoint: .bottom)) // Slightly darker background for event section
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(userSession: UserSession())
    }
}
