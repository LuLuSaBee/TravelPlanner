//
//  PlannerViewController.swift
//  TravelPlanner
//
//  Created by Louis SL Liu on 2021/8/9.
//

import UIKit

class ItineraryViewController: UITableViewController {
    var itineraryStore: ItineraryStore!
    var imageStore: ImageStore!

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    // MARK: Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        navigationItem.backButtonTitle = "Back"
    }

    // MARK: TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itineraryStore.allItineraries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItineraryCell", for: indexPath) as! ItineraryCell
        let itinerary = itineraryStore.allItineraries[indexPath.row]

        cell.nameLabel.text = itinerary.name
        cell.datetimeLabel.text = dateFormatter.string(from: itinerary.datetime)

        imageStore.fetchInterestingImages {
            (photosResult) in

            switch photosResult {
            case let .success(images):
                print("Successfully found \(images.count) photos.")
                if let firstPhoto = images.first {
                    self.imageStore.fetchImage(for: firstPhoto) {
                        (imageResult) in
                        switch imageResult {
                        case let .success(image):
                            cell.irineraryImage.image = image
                        case let .failure(error):
                            print("Error downloading image: \(error)")
                        }
                    }
                }
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
            }

        }

        return cell
    }

    func updateImageView(for photo: Image) {

    }
}
