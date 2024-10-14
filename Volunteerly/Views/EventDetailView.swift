//
//  EventDetailView.swift
//  Volunteerly
//
//  Created by Rahul Ramachandran on 14/10/24.
//

import SwiftUI
import MapKit
import FirebaseFirestore

struct EventDetailView: View {
    var event: Event

    // Remove static mapRegion initialization and use a state for MapCameraPosition
    @State private var cameraPosition: MapCameraPosition = .automatic

    var body: some View {
        ScrollView {
            VStack {
                // Map with a marker on the event's location using the latest SwiftUI Map API
                Map(position: $cameraPosition) {
                    Marker(event.title, coordinate: CLLocationCoordinate2D(latitude: event.coordinates.latitude, longitude: event.coordinates.longitude))
                }
                .frame(height: 250)
                .onAppear {
                    // Set cameraPosition dynamically based on the event's coordinates
                    cameraPosition = .region(MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: event.coordinates.latitude, longitude: event.coordinates.longitude),
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    ))
                }

                // Event details (below the map)
                HStack {
                    Text(event.title)
                        .font(.title)
                        .bold()
                    Spacer()
                    CategoryPillView(text: event.category)
                }
                .padding()

                VStack(alignment: .leading, spacing: 30) {
                    Text("**Organization**: \(event.organisation)")
                    Text("**Description**: \(event.description)")
                    HStack {
                        Text("**Start Date**: \(event.startDate, formatter: DateFormatterUtil.shared)")
                        Spacer()
                        Text("**End Date**: \(event.endDate, formatter: DateFormatterUtil.shared)")
                    }
                    Text("**Contact Email**: \(event.contactEmail)")
                }
                .padding(.horizontal)
                .padding(.top, 15)
                .padding(.bottom, 50)
                Button(action: {
                    
                }) {
                    Text("Sign Up for Event")
                        .foregroundColor(.white)
                        .font(.title3)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding()
            }
        }
    }
}

// Example preview
#Preview {
    EventDetailView(event: Event(title: "Beach Cleanup", organisation: "Ocean Care", coordinates: GeoPoint(latitude: -33.8688, longitude: 151.2093), startDate: Date(), endDate: Date(), description: "Help clean up the beach", category: "Environmental", contactEmail: "contact@oceancare.org"))
}
