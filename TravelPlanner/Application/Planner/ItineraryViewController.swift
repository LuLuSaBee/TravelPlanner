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

    var deleteButton: UIBarButtonItem!

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    // MARK: - Test
    func performInspect(_ indexPath: IndexPath) {
        Swift.debugPrint("inspect: \(indexPath)")
    }

    // MARK: - Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        navigationItem.backButtonTitle = "Back"
        setNavigationItemLeftButtonToEditButton()

        deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteRowsByMultipleSelection(sender:)))
    }

    // MARK: - TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    // MARK: Group
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Day \(section + 1)"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itineraryStore.allItineraries.count
    }

    // MARK: Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItineraryCell", for: indexPath) as! ItineraryCell
        let itinerary = itineraryStore.allItineraries[indexPath.row]
        let image = imageStore.getImage(forKey: itinerary.itineraryKey)
        
        let viewModel = ItineraryViewModel(image: image, itinerary: itinerary)
        cell.viewModel = viewModel

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteStoreDatas(deleteAt: indexPath)

            deleteTableViewRows(deleteAt: [indexPath])
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isEditing {
            navigationItem.leftBarButtonItem = deleteButton
        }
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.indexPathsForSelectedRows == nil {
            setNavigationItemLeftButtonToEditButton()
        }
    }

    @objc func deleteRowsByMultipleSelection(sender: UIBarButtonItem) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                deleteStoreDatas(deleteAt: indexPath)
            }

            deleteTableViewRows(deleteAt: selectedRows)
            setNavigationItemLeftButtonToEditButton()
        }
    }

    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
            previewProvider: nil,
            actionProvider: {
                suggestedActions in
                let inspectAction =
                    UIAction(title: "Delete", image: UIImage(systemName: "trash"),
                    attributes: .destructive) { action in
                    self.deleteStoreDatas(deleteAt: indexPath)

                    self.deleteTableViewRows(deleteAt: [indexPath])
                }
                return UIMenu(title: "", children: [inspectAction])
            })
    }

    func deleteStoreDatas(deleteAt indexPath: IndexPath) {
        let itinerary = itineraryStore.allItineraries[indexPath.row]
        itineraryStore.removeItinerary(itinerary)
        imageStore.deleteImage(forKey: itinerary.itineraryKey)
    }

    func deleteTableViewRows(deleteAt rows: [IndexPath]) {
        tableView.deleteRows(at: rows, with: .automatic)
    }

    // MARK: - Segues
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !self.isEditing
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showItinerary":
            showItinerary(segue: segue)
        case "addItinerary":
            addItinerary(segue: segue)
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }

    private func showItinerary(segue: UIStoryboardSegue) {
        if let row = tableView.indexPathForSelectedRow?.row {
            let itinerary = itineraryStore.allItineraries[row]
            let detailViewController = segue.destination as! DetailViewController
            segueToDetailView(in: detailViewController, show: itinerary)
        }
    }

    private func addItinerary(segue: UIStoryboardSegue) {
        let itinerary = itineraryStore.createItinerary()

        if let index = itineraryStore.allItineraries.firstIndex(of: itinerary) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }

        let detailViewController = segue.destination as! DetailViewController
        detailViewController.isAddMode = true

        segueToDetailView(in: detailViewController, show: itinerary)
    }

    private func segueToDetailView(in viewController: DetailViewController, show itinerary: Itinerary) {
        viewController.itinerary = itinerary
        viewController.imageStore = imageStore
        viewController.saveChanges = {
            self.itineraryStore.saveItinerary()
        }
    }

    // MARK: -
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
    }

    private func setNavigationItemLeftButtonToEditButton() {
        navigationItem.leftBarButtonItem = editButtonItem
    }
}
