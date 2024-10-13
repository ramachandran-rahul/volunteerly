//
//  CustomTextFieldModifier.swift
//  Volunteerly
//
//  Created by Rahul Ramachandran on 13/10/24.
//

import Foundation
import SwiftUI

struct CustomTextFieldModifier: ViewModifier {
    var iconName: String  // Icon to be displayed in the text field

    func body(content: Content) -> some View {
        content
            .padding(.leading, 40)
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            .shadow(color: Color.gray.opacity(0.3), radius: 3, x: 0, y: 3)
            .overlay(
                HStack {
                    Image(systemName: iconName)
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 10)
                }
            )
            .padding(.horizontal)
    }
}

extension View {
    func customTextFieldStyle(iconName: String) -> some View {
        self.modifier(CustomTextFieldModifier(iconName: iconName))
    }
}
