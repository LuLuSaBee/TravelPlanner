//
//  DetailViewController.swift
//  TravelPlanner
//
//  Created by Louis SL Liu on 2021/8/11.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    // MARK: - Variable
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var nameField: UITextField!
    @IBOutlet private var datetimeField: UITextField!
    @IBOutlet private var descriptionTextView: UITextView!
    
    private var datetimePicker = UIDatePicker()
    var itinerary: Itinerary!
    var isAddMode = false
    var saveChanges = { }
    var imageStore: ImageStore!

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    // MARK: - Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        editButtonItem.action = #selector(editButtonItemClick)
        navigationItem.rightBarButtonItem = editButtonItem
    }

    // MARK: - Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction private func backgroungTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    // MARK: - DatetimePicker
    private func createDatetimePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDatetimePick))
        toolbar.setItems([doneButton], animated: true)

        datetimeField.inputAccessoryView = toolbar

        datetimePicker.datePickerMode = .dateAndTime
        datetimePicker.preferredDatePickerStyle = .wheels
        datetimeField.inputView = datetimePicker
    }

    @objc private func doneDatetimePick() {
        datetimeField.text = dateFormatter.string(from: datetimePicker.date)
        let _ = self.textFieldShouldReturn(datetimeField)
    }

    //MARK: - View
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameField.text = itinerary.name
        datetimeField.text = dateFormatter.string(from: itinerary.datetime)
        descriptionTextView.text = itinerary.description

        self.setEditing(isAddMode)

        setImageViewImage()

        createDatetimePicker()
    }

    @objc private func setImageViewImage() {
        if let displayImage = imageStore.getImage(forKey: itinerary.itineraryKey) {
            imageView.image = displayImage
        } else {
            imageStore.fetchRandomImageAndSetByKey(key: itinerary.itineraryKey)
            let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(self.setImageViewImage), name: Notification.Name.setImageDone, object: nil)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    // MARK: - Editing
    override func setEditing(_ editing: Bool, animated: Bool = true) {
        super.setEditing(editing, animated: animated)
        setEditableTextFieldStyle(isEditing: editing)
    }

    private func setEditableTextFieldStyle(isEditing: Bool) {
        nameField.isUserInteractionEnabled = isEditing
        nameField.borderStyle = isEditing ? .roundedRect : .none
        nameField.placeholder = isEditing ? "Name" : ""

        datetimeField.isUserInteractionEnabled = isEditing
        datetimeField.borderStyle = isEditing ? .roundedRect : .none

        descriptionTextView.isEditable = isEditing
        descriptionTextView.textColor = isEditing ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1): #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        descriptionTextView.backgroundColor = isEditing ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1): UIColor.systemBackground
    }

    @objc private func editButtonItemClick() {
        if self.isEditing {
            itinerary.name = nameField.text ?? ""
            itinerary.datetime = datetimePicker.date
            itinerary.description = descriptionTextView.text ?? ""
            saveChanges()
        }
        self.setEditing(!self.isEditing)
        switchBackButtonVisible(isnotVisable: self.isEditing)
    }
    
    private func switchBackButtonVisible(isnotVisable: Bool){
        navigationItem.hidesBackButton = isnotVisable
    }
}
