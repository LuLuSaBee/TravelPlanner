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
    
    var viewModel: ItineraryViewModel? {
        didSet {
            if oldValue != nil {
                disposeBag = nil
            }
            guard let viewModel = viewModel else { return }
            
            let bag = DisposeBag()
            viewModel.output.irineraryImageObservable
                .bind { [weak self] in
                    self?.irineraryImage.image = $0
                }
                .disposed(by: bag)
            
            viewModel.output.nameLabelTextObservable
                .bind { [weak self] in
                    self?.nameLabel.text = $0
                }
                .disposed(by: bag)
            
            viewModel.output.datetimeLabelTextObservable
                .bind { [weak self] in
                    self?.datetimeLabel.text = $0
                }
                .disposed(by: bag)
            
            disposeBag = bag
        }
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.input.setImageView(nil)
        viewModel = nil
    }
}
