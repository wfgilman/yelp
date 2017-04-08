//
//  SortCell.swift
//  Yelp
//
//  Created by Will Gilman on 4/8/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class SortCell: UITableViewCell {

    
    @IBOutlet weak var sortLabel: UILabel!
    @IBOutlet weak var sortCheckboxImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.sortCheckboxImageView.image = UIImage(named: "uncheckbox")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
