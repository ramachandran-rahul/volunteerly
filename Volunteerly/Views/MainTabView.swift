//
//  MainTabView.swift
//  Volunteerly
//
//  Created by Rahul Ramachandran on 14/10/24.
//

import SwiftUI

struct MainTabView: View {
    @ObservedObject var userSession: UserSession
    @EnvironmentObject var eventsViewModel: EventsViewModel

    var body: some View {
        TabView {
            OpportunitiesView()
                .tabItem {
                    Label("Opportunities", systemImage: "list.bullet")
                }
            
            ProfileView(userSession: userSession)
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
    }
}

#Preview {
    MainTabView(userSession: UserSession())
        .environmentObject(EventsViewModel()) 
}
