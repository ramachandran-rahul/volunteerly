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
                
                Text("It's great to see you back!").padding(.bottom, 5)
                
                Text("Here are all the volunteering opportuntities we found for you!")
            }.padding()
            
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
        }
    }
}

#Preview {
    OpportunitiesView()
        .environmentObject(EventsViewModel())
}
