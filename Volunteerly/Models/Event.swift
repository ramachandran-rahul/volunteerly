//
//  Event.swift
//  Volunteerly
//
//  Created by Rahul Ramachandran on 14/10/24.
//

import Foundation
import FirebaseFirestore

struct Event: Identifiable, Codable {
    @DocumentID var id: String?  // The document ID from Firestore
    var title: String
    var organisation: String
    var coordinates: GeoPoint  // Use Firebase's GeoPoint for coordinates
    var startDate: Date
    var endDate: Date
    var description: String
    var category: String
    var contactEmail: String
}
