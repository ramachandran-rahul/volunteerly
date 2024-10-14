//
//  DateFormatterUtil.swift
//  Volunteerly
//
//  Created by Rahul Ramachandran on 14/10/24.
//

import Foundation

struct DateFormatterUtil {
    static let shared: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}
