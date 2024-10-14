//
//  EventTileView.swift
//  Volunteerly
//
//  Created by Rahul Ramachandran on 14/10/24.
//

import SwiftUI

struct EventTileView: View {
    var isEventComplete: Bool = false;
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Volunteering Opportunity Name")
                .font(.headline)
                .bold()
            Text("**Organization**: Example Organization")
                .font(.subheadline)
            Text("**Dates**: 10th Oct - 12th Oct, 2024")
                .font(.subheadline)
            CategoryPillView(text: "Environmental").padding(.top, 5)
            HStack {
                Spacer()
                Image(systemName: "checkmark.circle.fill").foregroundStyle(Color.green)
                Text(isEventComplete ? "Completed" : "Registered")
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
    }
}

#Preview {
    EventTileView()
}
