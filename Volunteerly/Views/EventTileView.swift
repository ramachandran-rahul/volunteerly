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
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var showEventDetail = false
    
    // Computed properties to check the event status based on the current date
        private var currentDate: Date {
            return Date()
        }
        
        private var isEventBooked: Bool {
            return userViewModel.bookedEvents.contains(event.id ?? "")
        }
        
        private var isOngoing: Bool {
            return currentDate >= event.startDate && currentDate <= event.endDate
        }
        
        private var isCompleted: Bool {
            return currentDate > event.endDate
        }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .top) {
                Text(event.title)
                    .font(.headline)
                    .bold()
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                    Spacer()
                
                // Show status based on event dates and booking
                if isEventBooked {
                    if isCompleted {
                        StatusView(status: "Completed", color: .gray)
                    } else if isOngoing {
                        StatusView(status: "Ongoing", color: .orange)
                    } else {
                        StatusView(status: "Booked", color: .green)
                    }
                }
            }
            Text("**Organization**: \(event.organisation)")
                .font(.subheadline)
            Text("**Dates**: \(event.startDate, formatter: DateFormatterUtil.shared) - \(event.endDate, formatter: DateFormatterUtil.shared)")
                .font(.subheadline)
            CategoryPillView(text: event.category).padding(.top, 5)
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

struct StatusView: View {
    var status: String
    var color: Color
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(color)
            Text(status)
                .foregroundColor(color)
                .font(.subheadline)
        }
    }
}

#Preview {
    EventTileView(
        event: Event(
            title: "Beach Cleanup",
            organisation: "Ocean Care",
            coordinates: GeoPoint(latitude: -33.8688, longitude: 151.2093),
            startDate: Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            description: "Help clean up the beach",
            category: "Environmental",
            contactEmail: "contact@oceancare.org"
        )
    ).environmentObject(UserViewModel())
}
