//
//  ItineraryStore.swift
//  TravelPlanner
//
//  Created by Louis SL Liu on 2021/8/10.
//

import Foundation

class ItineraryStore {
    var allItineraries = [Itinerary]()

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
}
