//
//  DistanceCell.swift
//  Yelp
//
//  Created by Will Gilman on 4/7/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class DistanceCell: UITableViewCell {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var checkboxImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.checkboxImageView.image = UIImage(named: "uncheckbox")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
