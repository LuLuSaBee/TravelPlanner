//
//  ItineraryStore.swift
//  TravelPlanner
//
//  Created by Louis SL Liu on 2021/8/10.
//

import UIKit

class ItineraryStore {
    var allItineraries = [Itinerary]()
    private let itineraryArchiveURL: URL = {
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        return documentDirectory.appendingPathComponent("itinerary.plist")
    }()

    init() {
        readItinerary()
    }

    @discardableResult func createItinerary() -> Itinerary {
        let newItinerary = Itinerary(name: "", description: "", datetime: Date())

        allItineraries.append(newItinerary)
        saveItinerary()

        return newItinerary
    }

    func removeItinerary(_ itinerary: Itinerary) {
        if let index = allItineraries.firstIndex(of: itinerary) {
            allItineraries.remove(at: index)
            saveItinerary()
        }
    }

    private func readItinerary() {
        do {
            let data = try Data(contentsOf: itineraryArchiveURL)
            let unarchiver = PropertyListDecoder()
            let itineraries = try unarchiver.decode([Itinerary].self, from: data)
            allItineraries = itineraries
        } catch let encodingError {
            print("Error reading in saved itineraries:\n \(encodingError)")
        }
    }

    func saveItinerary() {
        do {
            print("Saving items to: \(itineraryArchiveURL)")
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allItineraries)
            try data.write(to: itineraryArchiveURL, options: [.atomic])
            print("Saved all of the items")
        } catch {
            print("Save Itinerary Error: \(error)")
        }
    }
}
