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
        "https://wallpaper.wiki/wp-content/uploads/2017/05/Moon-in-cold-lakes-nexus-wallpaper.jpg",
        "http://www.wallpaperawesome.com/wallpapers-awesome/wallpapers-full-hd-1080-x-1920-smatphone-htc-one-lumia-1520-lg-g2-galaxy-s4-s5-awesome/wallpaper-full-hd-1080-x-1920-smartphone-earth-exploding.jpg",
        "http://www.bhmpics.com/wallpapers/minions_2015-1080x1920.jpg",
        "http://thewallpaper.co/wp-content/uploads/2016/10/Abstract-1080x1920-Wallpaper-cool-images-hd-download-apple-background-wallpapers-windows-free-display-lovely-wallpapers-1080x1920-768x1365.jpg",
        "https://livewallpaper.info/wp-content/uploads/2017/08/Full-Hd-1080-X-1920-Smartphone-Black-Leave-1080-x-1920-wallpaper-wp60013582.jpg"
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
        let index = indexPath.row
        cell.photoImageView.image = nil
        
        if let url = URL(string: urls[index]) {
            let urlString = url.absoluteString
            let key = urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? urlString
            if let image = ImageCache.default.image(of: key) {
                let width = view.bounds.width
                let height = width * image.size.height / image.size.width
                cell.photoImageView.image = image
                cell.heightConstraint.constant = height
            } else {
                ImageCache.default.loadImage(atUrl: url, completion: { [weak self] (urlStr, _) in
                    guard let sSelf = self else {
                        return
                    }
                    guard urlString == urlStr else {
                        return
                    }
                    sSelf.tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
                })
            }
        }
        return cell
    }
    
}

