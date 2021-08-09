//
//  PlannerViewController.swift
//  TravelPlanner
//
//  Created by Louis SL Liu on 2021/8/9.
//

import UIKit

class PlannerViewController: UITableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func viewDidLoad() {
        tableView.rowHeight = UITableView.automaticDimension
    }
}
