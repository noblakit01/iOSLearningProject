//
//  ViewController.swift
//  AsyncTableViewCellHeightExample
//
//  Created by Minh Luan Tran on 11/28/17.
//  Copyright © 2017 Minh Luan Tran. All rights reserved.
//

import UIKit
import SwiftyImageCache

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let urls: [String] = [
        "https://static.pexels.com/photos/126407/pexels-photo-126407.jpeg",
        "http://www.readersdigest.ca/wp-content/uploads/2011/01/4-ways-cheer-up-depressed-cat.jpg",
        "https://ichef.bbci.co.uk/news/1024/cpsprodpb/693C/production/_95804962_p0517py6.jpg",
        "http://www.petmd.com/sites/default/files/cat-lady-blog.jpg",
        "http://www.lanlinglaurel.com/data/out/109/4898297-cat-picture.jpg"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        if let url = URL(string: urls[indexPath.row]) {
            cell.photoImageView.setUrl(url)
        }
        return cell
    }
    
}

