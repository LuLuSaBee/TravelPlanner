//
//  ItineraryCell.swift
//  TravelPlanner
//
//  Created by Louis SL Liu on 2021/8/10.
//

import UIKit
import RxSwift
import RxCocoa

class ItineraryCell: UITableViewCell {
    @IBOutlet var irineraryImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var datetimeLabel: UILabel!

    private var disposeBag: DisposeBag?
    
    var viewModel: ItineraryCellViewModelType? {
        didSet {
            if oldValue != nil {
                disposeBag = nil
            }
            guard let viewModel = viewModel else { return }
            
            irineraryImage.image = viewModel.output.irineraryImage
            nameLabel.text = viewModel.output.nameLabelText
            datetimeLabel.text = viewModel.output.datetimeLabelText
        }
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.input.setImage(nil)
        viewModel = nil
    }
}
