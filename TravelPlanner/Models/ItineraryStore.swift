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
        let newItinerary = Itinerary(name: "Test1", description: "介紹介紹", datetime: Date())

        allItineraries.append(newItinerary)

        return newItinerary
    }
}
