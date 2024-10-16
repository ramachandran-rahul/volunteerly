//
//  Event.swift
//  Volunteerly
//
//  Created by Rahul Ramachandran on 14/10/24.
//

import Foundation
import FirebaseFirestore

struct Event: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var organisation: String
    var coordinates: GeoPoint
    var startDate: Date
    var endDate: Date
    var description: String
    var category: String
    var contactEmail: String
}
