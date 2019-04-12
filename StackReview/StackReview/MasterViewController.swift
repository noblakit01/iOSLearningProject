/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class MasterViewController: UITableViewController {
  
  var pancakeHouses = [PancakeHouse]()
  @IBOutlet weak var showHideDetailButton: UIBarButtonItem!
  private var detailsHidden: Bool = true {
    didSet {
      for cell in tableView.visibleCells {
        if let cell = cell as? PancakeHouseTableViewCell, cell.showExtraDetails == detailsHidden {
            cell.animateShowExtraDetails(show: !detailsHidden)
        }
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let seedPancakeHouses = PancakeHouse.loadDefaultPancakeHouses() {
      pancakeHouses += seedPancakeHouses
      pancakeHouses = pancakeHouses.sorted { $0.name < $1.name }
    }
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 100
  }
  
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
    super.viewWillAppear(animated)
  }

  // MARK: - Segues
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if let controller = (segue.destination as! UINavigationController).topViewController as? PancakeHouseViewController {
                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                    controller.navigationItem.leftItemsSupplementBackButton = true
                    let pancakeHouse = pancakeHouses[indexPath.row]
                    controller.pancakeHouse = pancakeHouse
                }
            }
        }
    }
  
  // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pancakeHouses.count
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let pancakeHouse = pancakeHouses[indexPath.row]
        if let cell = cell as? PancakeHouseTableViewCell {
            cell.pancakeHouse = pancakeHouse
            cell.showExtraDetails = !detailsHidden
        } else {
            cell.textLabel?.text = pancakeHouse.name
        }
        
        return cell
    }
  
  @IBAction func handleShowHideDetailTapped(sender: AnyObject) {
    if detailsHidden {
      showHideDetailButton.title = "Hide Detail"
    } else {
      showHideDetailButton.title = "Show Detail"
    }
    detailsHidden = !detailsHidden
  }
}

