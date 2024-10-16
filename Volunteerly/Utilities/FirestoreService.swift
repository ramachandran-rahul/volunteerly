//
//  FirestoreService.swift
//  Volunteerly
//
//  Created by Rahul Ramachandran on 14/10/24.
//

import FirebaseFirestore
import FirebaseAuth

class FirestoreService {
    private let db = Firestore.firestore()
    
    // Fetch events that match user's preferences
    func fetchEvents(for userID: String, completion: @escaping ([Event]) -> Void) {
        let userRef = db.collection("users").document(userID)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let userPreferences = document.get("preferences") as? [String] ?? []
                
                // If user has no preferences, return empty array
                guard !userPreferences.isEmpty else {
                    completion([]) // Return empty array
                    return
                }
                
                // Fetch events that match the user's preferences and have a start date in the future
                self.db.collection("events")
                    .whereField("category", in: userPreferences) // Filter by user's preferences
                    .whereField("startDate", isGreaterThanOrEqualTo: Date()) // Filter for future events
                    .order(by: "startDate") // Order by start date
                    .getDocuments { (querySnapshot, error) in
                        if let error = error {
                            print("Error fetching events: \(error.localizedDescription)")
                            completion([]) // Return empty array on failure
                            return
                        }
                        
                        let events = querySnapshot?.documents.compactMap { document -> Event? in
                            let data = document.data()
                            
                            guard
                                let title = data["title"] as? String,
                                let organisation = data["organisation"] as? String,
                                let coordinates = data["coordinates"] as? GeoPoint,
                                let startDate = (data["startDate"] as? Timestamp)?.dateValue(),
                                let endDate = (data["endDate"] as? Timestamp)?.dateValue(),
                                let description = data["description"] as? String,
                                let category = data["category"] as? String,
                                let contactEmail = data["contactEmail"] as? String
                            else { return nil }
                            
                            return Event(id: document.documentID, title: title, organisation: organisation, coordinates: coordinates, startDate: startDate, endDate: endDate, description: description, category: category, contactEmail: contactEmail)
                        } ?? []
                        
                        completion(events)
                    }
            } else {
                print("Error fetching user preferences: \(error?.localizedDescription ?? "No error message")")
                completion([]) // Return empty array on failure
            }
        }
    }
    
    func fetchEventsByIDs(eventIDs: [String], completion: @escaping ([Event]) -> Void) {
        guard !eventIDs.isEmpty else {
            completion([]) // Return empty array if no event IDs are provided
            return
        }
        
        // Fetch all events that match the given IDs
        db.collection("events").whereField(FieldPath.documentID(), in: eventIDs).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching events by IDs: \(error.localizedDescription)")
                completion([]) // Return empty array on failure
                return
            }
            
            let events = querySnapshot?.documents.compactMap { document -> Event? in
                let data = document.data()
                
                guard
                    let title = data["title"] as? String,
                    let organisation = data["organisation"] as? String,
                    let coordinates = data["coordinates"] as? GeoPoint,
                    let startDate = (data["startDate"] as? Timestamp)?.dateValue(),
                    let endDate = (data["endDate"] as? Timestamp)?.dateValue(),
                    let description = data["description"] as? String,
                    let category = data["category"] as? String,
                    let contactEmail = data["contactEmail"] as? String
                else { return nil }
                
                return Event(id: document.documentID, title: title, organisation: organisation, coordinates: coordinates, startDate: startDate, endDate: endDate, description: description, category: category, contactEmail: contactEmail)
            } ?? []
            
            completion(events)
        }
    }
}
