//
//  OpportunitiesView.swift
//  Volunteerly
//
//  Created by Rahul Ramachandran on 14/10/24.
//

import SwiftUI
import FirebaseAuth

struct OpportunitiesView: View {
    var body: some View {
        Text("Welcome back to Volunteerly,\n\(FirebaseAuth.Auth.auth().currentUser?.displayName ?? "User")")
            .font(.title)
            .padding()

        Text("Hello, OpportunitiesView!")
    }
}

#Preview {
    OpportunitiesView()
}
