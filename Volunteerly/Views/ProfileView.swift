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
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var eventsViewModel: EventsViewModel
    
    @State private var isEditPreferencesPresented = false
    
    let columns: [GridItem] = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Volunteer Profile")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 5)
                Text("This page is all about you. Find out more about your preferences, your profile, and all your events.")
                    .font(.body)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(FirebaseAuth.Auth.auth().currentUser?.displayName ?? "No Name")").font(.title2).fontWeight(.semibold)
                    Text("\(FirebaseAuth.Auth.auth().currentUser?.email ?? "No Email")").font(.body).fontWeight(.semibold).padding(.bottom)
                }
                
                Spacer()
                Button(action: userSession.logoutUser) {
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
                    .padding(.top, 5)
                }
            }
            .padding(.bottom, 1)
            .padding(.leading, 20)
            .padding(.trailing, 10)
            
            VStack {
                HStack {
                    Text("User Preferences:").font(.title3).fontWeight(.semibold)
                    Spacer()
                }
                // Display user preferences dynamically
                
                //                ["Environmental", "Social Impact", "Health & Safety", "Animal Welfare", "Sports"]
                LazyVGrid(columns: columns, alignment: .leading, spacing: 15) {
                    ForEach(userViewModel.preferences, id: \.self) { preference in
                        CategoryPillView(text: preference)
                    }
                    HStack {
                        Image(systemName: "pencil")
                        Text("Edit")
                            .font(.subheadline)
                    }
                    .foregroundColor(.red)
                    .padding(5)
                    .padding(.horizontal, 7)
                    .padding(.trailing, 3)
                    .background(Color.white)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.red, lineWidth: 1)
                    )
                    .fixedSize(horizontal: true, vertical: false)
                    .onTapGesture {
                        isEditPreferencesPresented.toggle()
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(red: 0.78, green: 0.86, blue: 0.88), Color(red: 0.78, green: 0.86, blue: 0.81)]),
                               startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                
                // Scrollable Events Section
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("\(FirebaseAuth.Auth.auth().currentUser?.displayName ?? "No Name")'s Events")
                            .font(.title2)
                            .bold()
                            .padding(.leading, 20)
                        
                        if userViewModel.bookedEvents.isEmpty {
                            HStack {
                                Spacer()
                                Text("No events found.")
                                    .foregroundColor(.gray)
                                    .padding(.top, 20)
                                Spacer()
                            }
                        } else {
                            // Display EventTiles for the booked events
                            VStack(spacing: 16) {
                                ForEach(userViewModel.bookedEvents, id: \.self) { eventID in
                                    if let event = eventsViewModel.getEvent(by: eventID) {
                                        EventTileView(event: event)
                                    } else {
                                        Text("Loading event details...")
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 1)
                        }
                    }
                    .padding(.vertical)
                }
                .refreshable {
                    // Fetch the latest events or user data when the user performs a pull-to-refresh action
                    eventsViewModel.fetchEvents {
                        print("Events refreshed")
                    }
                    userViewModel.fetchUserData {
                        print("User data refreshed")
                    }
                }
            }
        }
        .sheet(isPresented: $isEditPreferencesPresented) {
            EditPreferencesView(userViewModel: userViewModel, isPresented: $isEditPreferencesPresented).environmentObject(eventsViewModel)
        }

    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(userSession: UserSession())
            .environmentObject(UserViewModel())
    }
}
