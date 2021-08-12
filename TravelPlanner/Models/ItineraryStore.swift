//
//  ItineraryStore.swift
//  TravelPlanner
//
//  Created by Louis SL Liu on 2021/8/10.
//

import UIKit

class ItineraryStore {
    var allItineraries = [Itinerary]()
    let itineraryArchiveURL: URL = {
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        return documentDirectory.appendingPathComponent("itinerary.plist")
    }()

    init() {
        createItinerary()
    }

    @discardableResult func createItinerary() -> Itinerary {
        let newItinerary = Itinerary(name: "", description: "", datetime: Date())

        allItineraries.append(newItinerary)

        return newItinerary
    }

    func removeItinerary(_ itinerary: Itinerary) {
        if let index = allItineraries.firstIndex(of: itinerary) {
            allItineraries.remove(at: index)
        }
    }
    
    func saveChanges() throws {
        let encoder = PropertyListEncoder()
        let data = try encoder.encode(allItineraries)
        try data.write(to: itineraryArchiveURL, options: [.atomic])
    }
}
