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
                .background(randomColor(for: text))
                .cornerRadius(20)
        }
        
        // Function to generate a random color based on the text value
        private func randomColor(for text: String) -> Color {
            let colors: [Color] = [.purple, .blue, .green, .red, .orange, .pink, .indigo, .teal]
            let index = abs(text.hashValue) % colors.count
            return colors[index]
        }
}

#Preview {
    CategoryPillView(text: "SwiftUI")
}
