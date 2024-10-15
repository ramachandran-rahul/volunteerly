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
                .environmentObject(eventsViewModel)
        }
        .onAppear {
            customiseTabBarAppearance()
        }
    }
    
    // Function to customise the TabBar appearance
    private func customiseTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        appearance.shadowColor = UIColor.black.withAlphaComponent(0.3)
        appearance.shadowImage = nil
        
        // Apply the custom appearance to the UITabBar
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView(userSession: UserSession())
        .environmentObject(EventsViewModel())
}
