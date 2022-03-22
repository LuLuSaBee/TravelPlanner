//
//  ItineraryCellViewModel.swift
//  TravelPlanner
//
//  Created by 劉聖龍 on 2022/3/22.
//

import Foundation
import UIKit
import RxSwift

protocol ItinerartCellViewModelInput {
    func setImageView(_ imageView: UIImage?)
}

protocol ItineraryCellViewModelOutput {
    var irineraryImageObservable: Observable<UIImage?> { get }
    var nameLabelTextObservable: Observable<String> { get }
    var datetimeLabelTextObservable: Observable<String> { get }
}

protocol ItineraryCellViewModelType {
    var input: ItinerartCellViewModelInput { get }
    var output: ItineraryCellViewModelOutput { get }
}

class ItineraryViewModel: ItineraryCellViewModelType {
    private var imageView: UIImage?
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
        self.imageView = image
        self.name = itinerary.name
        self.datetime = itinerary.datetime
    }
}

extension ItineraryViewModel: ItinerartCellViewModelInput {
    func setImageView(_ imageView: UIImage?) {
        self.imageView = imageView
    }
}

extension ItineraryViewModel: ItineraryCellViewModelOutput {
    var irineraryImageObservable: Observable<UIImage?> { .just(self.imageView) }
    var nameLabelTextObservable: Observable<String> { .just(self.name) }
    var datetimeLabelTextObservable: Observable<String> {
        .just(self.dateFormatter.string(from: self.datetime))
    }
}
