//
//  TableViewCell.swift
//  AsyncTableViewCellHeightExample
//
//  Created by Minh Luan Tran on 11/29/17.
//  Copyright © 2017 Minh Luan Tran. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
