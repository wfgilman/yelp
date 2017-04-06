//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Will Gilman on 4/5/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: FiltersViewControllerDelegate?
    
    var categories: [[String : String]]!
    var switchStates = [Int : Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        categories = yelpCategories()
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
     @IBAction func onSearchButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        var filters = [String : AnyObject]()
        var selectedCategories = [String]()
        
        for (row, isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories as AnyObject
        }
        
        delegate?.filtersViewController!(filtersViewController: self, didUpdateFilters: filters)
    }   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
        
        cell.switchLabel.text = categories[indexPath.row]["name"]
        cell.delegate = self
        
        cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
        
        return cell
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)!
        
        switchStates[indexPath.row] = value
    }
    
    func yelpCategories() -> [[String:String]] {
            return [["name" : "Middle Eastern", "code" : "mideastern"],
                    ["name" : "Thai", "code" : "thai"]]
    }

}
