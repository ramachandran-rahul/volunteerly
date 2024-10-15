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
    @State var showSignUpConfirmation: Bool = false
    @State var showBackOutConfirmation: Bool = false
    var event: Event
    @EnvironmentObject var userViewModel: UserViewModel

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

                ScrollView {
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
                    
                    // Show "Booked" text if the user has already booked the event
                    if userViewModel.bookedEvents.contains(event.id ?? "") {
                        HStack {
                            Image(systemName: "checkmark.circle.fill").font(.title2).foregroundStyle(Color.green)
                            Text("You are registered for this event.")
                                .font(.headline)
                                .foregroundColor(.green)
                        }
                        .padding(.top, 50)
                    }
                }.frame(height: 350)
                
                // Show the button based on whether the user has booked the event
                if userViewModel.bookedEvents.contains(event.id ?? "") {
                    // If the user has booked the event, allow them to "Back Out" if the event hasn't started
                    if Date() < event.startDate {
                        Button(action: {
                            showBackOutConfirmation = true
                        }) {
                            Text("Back Out of Event")
                                .foregroundColor(.white)
                                .font(.title3)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        .padding()
                        .alert(isPresented: $showBackOutConfirmation) {
                            Alert(
                                title: Text("Confirm Back Out"),
                                message: Text("Are you sure you want to back out of this event?"),
                                primaryButton: .default(Text("Yes"), action: {
                                    guard let eventID = event.id else {
                                        print("Invalid event ID")
                                        return
                                    }
                                    userViewModel.updateEventBooking(eventID: eventID, shouldBook: false) { success in
                                        if success {
                                            print("Successfully backed out of the event!")
                                        } else {
                                            print("Failed to back out of event.")
                                        }
                                    }
                                }),
                                secondaryButton: .cancel()
                            )
                        }
                    }
                } else {
                    // If the user hasn't booked the event, show the "Sign Up" button
                    Button(action: {
                        showSignUpConfirmation = true
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
                    .alert(isPresented: $showSignUpConfirmation) {
                        Alert(
                            title: Text("Confirm Sign-Up"),
                            message: Text("Are you sure you want to sign up for this event?"),
                            primaryButton: .default(Text("Yes"), action: {
                                guard let eventID = event.id else {
                                    print("Invalid event ID")
                                    return
                                }
                                userViewModel.updateEventBooking(eventID: eventID, shouldBook: true) { success in
                                    if success {
                                        print("Event successfully booked!")
                                    } else {
                                        print("Failed to book event.")
                                    }
                                }
                            }),
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
        }
    }
}

// Example preview
#Preview {
    EventDetailView(event: Event(title: "Beach Cleanup", organisation: "Ocean Care", coordinates: GeoPoint(latitude: -33.8688, longitude: 151.2093), startDate: Date(), endDate: Date(), description: "Help clean up the beach", category: "Environmental", contactEmail: "contact@oceancare.org"))
}
