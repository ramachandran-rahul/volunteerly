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
        VStack {
            Text("Welcome back to Volunteerly,\n\(FirebaseAuth.Auth.auth().currentUser?.displayName ?? "User")")
                .font(.title)
                .padding()
            
            Text("Here are all the volunteering opportuntities we found for you!")
                .font(.headline)
            
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
