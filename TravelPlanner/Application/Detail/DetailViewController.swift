//
//  DetailViewController.swift
//  TravelPlanner
//
//  Created by Louis SL Liu on 2021/8/11.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Variable
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var datetimeField: UITextField!
    @IBOutlet var descriptionField: UITextField!

    var itinerary: Itinerary!
    var isAddMode = false
    var datetimePicker = UIDatePicker()

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
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
        setEditableTextFieldStyle(isEditing: isAddMode)
        
        createDatetimePicker()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        setEditableTextFieldStyle(isEditing: editing)
    }

    func setEditableTextFieldStyle(isEditing: Bool) {
        if nameField != nil {
            nameField.isUserInteractionEnabled = isEditing
            datetimeField.isUserInteractionEnabled = isEditing
            descriptionField.isUserInteractionEnabled = isEditing

            nameField.borderStyle = isEditing ? .roundedRect : .none
            datetimeField.borderStyle = isEditing ? .roundedRect : .none
            descriptionField.borderStyle = isEditing ? .roundedRect : .none
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func backgroungTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func createDatetimePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDatetimePick))
        toolbar.setItems([doneButton], animated: true)
        
        datetimeField.inputAccessoryView = toolbar
        
        datetimePicker.datePickerMode = .dateAndTime
        datetimePicker.preferredDatePickerStyle = .wheels
        datetimeField.inputView = datetimePicker
    }
    
    @objc func doneDatetimePick(){
        datetimeField.text = dateFormatter.string(from: datetimePicker.date)
        let _ = self.textFieldShouldReturn(datetimeField)
    }
}
