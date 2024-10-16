//
//  OpportunitiesView.swift
//  Volunteerly
//
//  Created by Rahul Ramachandran on 14/10/24.
//

import SwiftUI
import FirebaseAuth

struct OpportunitiesView: View {
    @EnvironmentObject var eventsViewModel: EventsViewModel
    
    var body: some View {
        VStack  {
            VStack (alignment: .leading) {
                Text("Welcome back to Volunteerly, \(FirebaseAuth.Auth.auth().currentUser?.displayName ?? "User")!")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.vertical)
                
                Text("It's great to see you back!")
                    .font(.body)
                    .foregroundColor(.gray)
                if eventsViewModel.events.isEmpty {
                    // Display message when there are no events
                    VStack {
                        Text("Unfortunately, we have no opportunities that match your currently selected preferences.")
                        Text("Please update your preferences in the profile section.").padding(.top)
                        Spacer()
                    }
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, 200) // Add padding to center the message
                } else {
                    // Default message when there are events
                    Text("Here are all the volunteering opportunities we found for you!")
                        .font(.body)
                        .foregroundColor(.gray)
                }

            }.padding()
            
            if !eventsViewModel.events.isEmpty {
                ScrollView {
                    VStack(alignment: .leading) {
                        VStack(spacing: 16) {
                            ForEach(eventsViewModel.events) { event in
                                EventTileView(event: event)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 1)
                    }
                }
                .refreshable {
                    // Fetch events when the user pulls down to refresh
                    eventsViewModel.fetchEvents {
                        // Handle completion if necessary
                    }
                }
            }
        }
        .onAppear {
            // Fetch events when the view appears
            eventsViewModel.fetchEvents {
                // Handle completion if necessary
            }
        }
    }
}

#Preview {
    OpportunitiesView()
        .environmentObject(EventsViewModel())
}
