//
//  PlaceViewCell.swift
//  Dictator
//
//  Created by Eran Kaufman on 5/8/16.
//  Copyright © 2016 Eran Kaufman. All rights reserved.
//

import UIKit

class PlaceViewCell: UITableViewCell {
    
    @IBOutlet var placeNameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Turn off cell indentation
        self.separatorInset = UIEdgeInsetsZero
        self.layoutMargins = UIEdgeInsetsZero
        self.preservesSuperviewLayoutMargins = false
    }
    
}
