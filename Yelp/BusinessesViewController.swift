//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FiltersViewControllerDelegate, UISearchBarDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var businesses: [Business]!
    var filteredBusinesses: [Business]!
    var filters = [String : AnyObject]()
    var isMoreDataLoading: Bool! = false
    var offset: Int = 0
    var limit: Int = 20
    var loadingMoreView: InfiniteScrollActivityView?
    var resetContentOffset: Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        // Configure search bar.
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Restaurants"
        searchBar.delegate =  self
        navigationItem.titleView = searchBar
        
        // Infinite scrolling setup.
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
        // Fetch businesses.
        let categories = self.filters["categories"] as? [String]
        let deals = self.filters["offeringDeal"] as? Bool
        let distance = self.filters["distance"] as? Int
        let sort = YelpSortMode(rawValue: (self.filters["sortBy"] as? Int ?? 0)!)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Business.searchWithTerm(term: "Restaurants", sort: sort, categories: categories, deals: deals, distance: distance, limit: self.limit, offset: self.offset) { (businesses: [Business]?, error: Error?) -> Void in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            self.businesses = businesses
            self.filteredBusinesses = self.businesses
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if resetContentOffset! {
            tableView.contentOffset.y = -64.0
        }
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
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        
        // Since we're initiating a new search, reset offset to zero.
        self.offset = 0
        
        self.filters = filters
        
        let categories = self.filters["categories"] as? [String]
        let deals = self.filters["offeringDeal"] as? Bool
        let distance = self.filters["distance"] as? Int
        let sort = YelpSortMode(rawValue: (self.filters["sortBy"] as? Int)!)
        
        Business.searchWithTerm(term: "Restaurants", sort: sort, categories: categories, deals: deals, distance: distance, limit: nil, offset: self.offset) { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.filteredBusinesses = self.businesses
            self.tableView.reloadData()
        }
    }
    
    func didSearch(filtersViewController: FiltersViewController, resetContentOffset didSearch: Bool) {
        self.resetContentOffset = didSearch
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let categories = self.filters["categories"] as? [String]
        let deals = self.filters["offeringDeal"] as? Bool
        let distance = self.filters["distance"] as? Int
        let sort = YelpSortMode(rawValue: (self.filters["sortBy"] as? Int ?? 0)!)
        
        if !isMoreDataLoading {
            
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if (scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                
                isMoreDataLoading = true
                
                // Get the next 20 results
                self.offset += 20
                
                // Display the loadingMoreView
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                Business.searchWithTerm(term: "Restaurants", sort: sort, categories: categories, deals: deals, distance: distance, limit: self.limit, offset: self.offset) { (businesses: [Business]?, error: Error?) -> Void in
                    
                    self.isMoreDataLoading = false
                    self.loadingMoreView!.stopAnimating()
                    
                    if businesses != nil {
                        for business in businesses! {
                            self.businesses.append(business)
                        }
                    }
                    self.filteredBusinesses = self.businesses
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // Segue method.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
    }
    

}
