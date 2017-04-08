//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FiltersViewControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var businesses: [Business]!
    var filteredBusinesses: [Business]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Restaurants"
        searchBar.delegate =  self
        navigationItem.titleView = searchBar
        
        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.filteredBusinesses = self.businesses
            self.tableView.reloadData()
            }
        )
        
    }
    
    // Delegate methods.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredBusinesses != nil {
            return filteredBusinesses!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        cell.business = filteredBusinesses[indexPath.row]
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredBusinesses = searchText.isEmpty ? businesses : businesses?.filter {
            $0.name?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = nil
        searchBar.resignFirstResponder()
        filteredBusinesses = businesses
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        
        let categories = filters["categories"] as? [String]
        let deals = filters["offeringDeal"] as? Bool
        let distance = filters["distance"] as? Int
        let sort = YelpSortMode(rawValue: (filters["sortBy"] as? Int)!)
        
        Business.searchWithTerm(term: "Restaurants", sort: sort, categories: categories, deals: deals, distance: distance) { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.filteredBusinesses = self.businesses
            self.tableView.reloadData()
        }
    }
    
    
}
