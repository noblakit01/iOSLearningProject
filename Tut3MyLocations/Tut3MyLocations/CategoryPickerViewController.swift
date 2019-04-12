//
//  CategoryPickerViewController.swift
//  Tut3MyLocations
//
//  Created by luan on 6/24/16.
//  Copyright © 2016 luantran. All rights reserved.
//

import UIKit

class CategoryPickerViewController: UITableViewController {

    var selectedCategoryName = ""
    var selectedIndexPath = NSIndexPath()
    
    let categories = [
        "No Category",
        "Apple Store",
        "Bar",
        "Bookstore",
        "Club",
        "Grocery Store",
        "Historic Building",
        "House",
        "Icecream Vendor",
        "Landmark",
        "Park" ]
    
    // MARK: UIViewControllerDelagate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorColor = UIColor(white: 1.0, alpha: 0.2)
        tableView.indicatorStyle = .White
        
        for i in 0..<categories.count where categories[i] == selectedCategoryName {
            selectedIndexPath = NSIndexPath(forRow: i, inSection: 0)
            break
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PickedCategory" {
            if let cell = sender as? UITableViewCell {
                if let indexPath = tableView.indexPathForCell(cell) {
                    selectedCategoryName = categories[indexPath.row]
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath)

        let categoryNameLabel = cell.viewWithTag(50) as! UILabel
        categoryNameLabel.text = categories[indexPath.row]
        
        if selectedCategoryName == categories[indexPath.row] {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        cell.selectedBackgroundView = selectedView
    }
}
