//
//  ItineraryCellViewModel.swift
//  TravelPlanner
//
//  Created by 劉聖龍 on 2022/3/22.
//

import Foundation
import UIKit

protocol ItinerartCellViewModelInput {
    func setImage(_ image: UIImage?)
}

protocol ItineraryCellViewModelOutput {
    var irineraryImage: UIImage? { get }
    var nameLabelText: String { get }
    var datetimeLabelText: String { get }
}

protocol ItineraryCellViewModelType {
    var input: ItinerartCellViewModelInput { get }
    var output: ItineraryCellViewModelOutput { get }
}

class ItineraryCellViewModel: ItineraryCellViewModelType {
    private var image: UIImage?
    private var name: String
    private var datetime: Date
    
    var input: ItinerartCellViewModelInput { self }
    var output: ItineraryCellViewModelOutput { self }

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    init(image: UIImage?, itinerary: Itinerary) {
        self.image = image
        self.name = itinerary.name
        self.datetime = itinerary.datetime
    }
}

extension ItineraryCellViewModel: ItinerartCellViewModelInput {
    func setImage(_ image: UIImage?) {
        self.image = image
    }
}

extension ItineraryCellViewModel: ItineraryCellViewModelOutput {
    var irineraryImage:UIImage? { self.image }
    var nameLabelText: String { self.name }
    var datetimeLabelText: String { self.dateFormatter.string(from: self.datetime) }
}
