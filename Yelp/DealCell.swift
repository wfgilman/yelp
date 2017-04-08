//
//  DealCell.swift
//  Yelp
//
//  Created by Will Gilman on 4/7/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol DealCellDelegate {
    @objc optional func dealCell(dealCell: DealCell, didChangeValue: Bool)
}

class DealCell: UITableViewCell {

    @IBOutlet weak var dealOnSwitch: UISwitch!
    
    weak var delegate: DealCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dealOnSwitch.addTarget(self, action: #selector(DealCell.dealSwitchValueChanged), for: UIControlEvents.valueChanged)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func dealSwitchValueChanged() {
        // print("dealSwitchValueChanged to: \(dealOnSwitch.isOn)")
        delegate?.dealCell?(dealCell: self, didChangeValue: dealOnSwitch.isOn)
    }


}
