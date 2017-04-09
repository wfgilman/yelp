//
//  BusinessCell.swift
//  Yelp
//
//  Created by Will Gilman on 4/5/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var ratingsImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    var business: Business! {
        didSet {
            nameLabel.text = business.name
            thumbImageView.alpha = 0.0
            thumbImageView.setImageWith(business.imageURL!)
            UIView.animate(withDuration: 0.15, animations: { () -> Void in
                self.thumbImageView.alpha = 1.0
            })
            ratingsImageView.setImageWith(business.ratingImageURL!)
            distanceLabel.text = business.distance
            reviewsCountLabel.text = ("\(business.reviewCount!) reviews")
            addressLabel.text = business.address
            categoriesLabel.text = business.categories
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        nameLabel.text = nil
        thumbImageView.image = nil
        ratingsImageView.image = nil
        distanceLabel.text = nil
        reviewsCountLabel.text = nil
        addressLabel.text = nil
        categoriesLabel.text = nil
    }

}
