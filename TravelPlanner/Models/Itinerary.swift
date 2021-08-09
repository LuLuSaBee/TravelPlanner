//
//  Itinerary.swift
//  TravelPlanner
//
//  Created by Louis SL Liu on 2021/8/9.
//

import Foundation

class Itinerary: Codable, Equatable {

    // MARK: - Variable
    var itineraryKey: String
    var name: String
    var description: String
    var datetime: Date


    // MARK: - Init Function
    init(name: String, description: String, datetime: Date) {
        self.itineraryKey = UUID().uuidString
        self.name = name
        self.description = description
        self.datetime = datetime
    }

    static func == (lhs: Itinerary, rhs: Itinerary) -> Bool {
        return lhs.itineraryKey == rhs.itineraryKey
    }
}
