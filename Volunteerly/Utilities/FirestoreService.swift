//
//  FirestoreService.swift
//  Volunteerly
//
//  Created by Rahul Ramachandran on 14/10/24.
//

import FirebaseFirestore

class FirestoreService {
    private let db = Firestore.firestore()

    func fetchEvents(completion: @escaping ([Event]) -> Void) {
        db.collection("events").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching events: \(error.localizedDescription)")
                
                if let firestoreError = error as NSError?, firestoreError.domain == FirestoreErrorDomain {
                    switch FirestoreErrorCode.Code(rawValue: firestoreError.code) {
                    case .permissionDenied:
                        print("Permission denied. User does not have access.")
                    default:
                        print("Firestore error occurred: \(firestoreError.localizedDescription)")
                    }
                }

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
