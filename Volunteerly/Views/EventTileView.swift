//
//  EventTileView.swift
//  Volunteerly
//
//  Created by Rahul Ramachandran on 14/10/24.
//

import SwiftUI
import FirebaseFirestore

struct EventTileView: View {
    var event: Event
    var isEventComplete: Bool = false;
    @State private var showEventDetail = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(event.title)
                .font(.headline)
                .bold()
            Text("**Organization**: \(event.organisation)")
                .font(.subheadline)
            Text("**Dates**: \(event.startDate, formatter: DateFormatterUtil.shared) - \(event.endDate, formatter: DateFormatterUtil.shared)")
                .font(.subheadline)
            CategoryPillView(text: event.category).padding(.top, 5)
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
        .onTapGesture {
            showEventDetail.toggle()
        }
        .sheet(isPresented: $showEventDetail) {
            EventDetailView(event: event)
        }
    }
}

#Preview {
    EventTileView(event: Event(title: "Beach Cleanup", organisation: "Ocean Care", coordinates: GeoPoint(latitude: -33.8688, longitude: 151.2093), startDate: Date(), endDate: Date(), description: "Help clean up the beach", category: "Environmental", contactEmail: "contact@oceancare.org"))
}
