//
//  CategoryPillView.swift
//  Volunteerly
//
//  Created by Rahul Ramachandran on 14/10/24.
//

import SwiftUI

struct CategoryPillView: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.subheadline)
            .foregroundColor(.white)
            .padding(5)
            .padding(.horizontal)
            .background(colorForCategory(text))
            .cornerRadius(20)
            .fixedSize(horizontal: true, vertical: false)
    }
    
    // Function to return a fixed color based on the text (category)
    private func colorForCategory(_ category: String) -> Color {
        switch category {
        case "Environmental":
            return .green
        case "Social Impact":
            return .purple
        case "Health & Safety":
            return .blue
        case "Animal Welfare":
            return .brown
        case "Sports":
            return .orange
        default:
            return .gray 
        }
    }
}

#Preview {
    CategoryPillView(text: "SwiftUI")
}
