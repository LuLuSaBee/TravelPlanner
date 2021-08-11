//
//  DetailViewController.swift
//  TravelPlanner
//
//  Created by Louis SL Liu on 2021/8/11.
//

import UIKit

class DetailViewController: UIViewController {
    // MARK: - Variable
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var datetimeField: UITextField!
    @IBOutlet var descriptionField: UITextField!

    var itinerary: Itinerary!
    var isAddMode = false

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    // MARK: - Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        navigationItem.rightBarButtonItem = editButtonItem
    }

    //MARK: -
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameField.text = itinerary.name
        datetimeField.text = dateFormatter.string(from: itinerary.datetime)
        descriptionField.text = itinerary.description
        setTextFieldsParamters(isEditing: isAddMode)
    }

    func setTextFieldsParamters(isEditing: Bool) {
        nameField.isUserInteractionEnabled = isEditing
        datetimeField.isUserInteractionEnabled = isEditing
        descriptionField.isUserInteractionEnabled = isEditing

        nameField.borderStyle = isEditing ? .roundedRect : .none
        datetimeField.borderStyle = isEditing ? .roundedRect : .none
        descriptionField.borderStyle = isEditing ? .roundedRect : .none
    }
}
