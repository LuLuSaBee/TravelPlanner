//
//  DetailViewController.swift
//  TravelPlanner
//
//  Created by Louis SL Liu on 2021/8/11.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    // MARK: - Variable
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var datetimeField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!

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

    // MARK: - Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func backgroungTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    // MARK: - DateTimePicker
    func createDatetimePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDatetimePick))
        toolbar.setItems([doneButton], animated: true)

        datetimeField.inputAccessoryView = toolbar

        datetimePicker.datePickerMode = .dateAndTime
        datetimePicker.preferredDatePickerStyle = .wheels
        datetimeField.inputView = datetimePicker
    }

    @objc func doneDatetimePick() {
        datetimeField.text = dateFormatter.string(from: datetimePicker.date)
        let _ = self.textFieldShouldReturn(datetimeField)
    }

    //MARK: -
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameField.text = itinerary.name
        datetimeField.text = dateFormatter.string(from: itinerary.datetime)
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
            nameField.borderStyle = isEditing ? .roundedRect : .none
            nameField.placeholder = isEditing ? "Name" : ""

            datetimeField.isUserInteractionEnabled = isEditing
            datetimeField.borderStyle = isEditing ? .roundedRect : .none

            descriptionTextView.isEditable = isEditing
            descriptionTextView.textColor = isEditing ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1): #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }
}
