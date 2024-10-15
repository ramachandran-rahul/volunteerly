//
//  EventsViewModel.swift
//  Volunteerly
//
//  Created by Rahul Ramachandran on 14/10/24.
//

import SwiftUI
import FirebaseAuth

class EventsViewModel: ObservableObject {
    @Published var events: [Event] = []
    private var firestoreService = FirestoreService()

    // Fetch events based on user's preferences
    func fetchEvents(completion: @escaping () -> Void) {
        guard let userID = FirebaseAuth.Auth.auth().currentUser?.uid else { return }
        
        firestoreService.fetchEvents(for: userID) { [weak self] fetchedEvents in
            DispatchQueue.main.async {
                self?.events = fetchedEvents
                completion()  // Notify completion
            }
        }
    }
    
    // Get an event by its ID
    func getEvent(by eventID: String) -> Event? {
        return events.first { $0.id == eventID }
    }
}
