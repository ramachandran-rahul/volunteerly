//
//  EventsViewModel.swift
//  Volunteerly
//
//  Created by Rahul Ramachandran on 14/10/24.
//

import SwiftUI
import FirebaseFirestore

class EventsViewModel: ObservableObject {
    @Published var events: [Event] = []
    private var firestoreService = FirestoreService()

    // Fetch events from Firestore
    func fetchEvents(completion: @escaping () -> Void) {
        firestoreService.fetchEvents { [weak self] fetchedEvents in
            DispatchQueue.main.async {
                self?.events = fetchedEvents
                completion()  // Notify completion
            }
        }
    }
}
