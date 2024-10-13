//
//  MainTabView.swift
//  Volunteerly
//
//  Created by Rahul Ramachandran on 14/10/24.
//

import SwiftUI

struct MainTabView: View {
    @ObservedObject var userSession: UserSession

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
}
