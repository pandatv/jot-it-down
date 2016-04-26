//
//  AJCExtenstions.swift
//  Jot It Down
//
//  Created by Andrey Baranov on 18/03/2016.
//  Copyright © 2016 PaPaPanda. All rights reserved.
//

import UIKit

// MARK: SEARCH CONTROLS
extension AllJotsController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterModelForSearchText(searchController.searchBar.text!)
    }
    
    func filterModelForSearchText(searchText: String) {
        let flattenedJots = sectionedJots.flatMap { $0 }
        filteredJots = flattenedJots.filter { jot in
            return jot.body.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        navigationItem.titleView = nil
        navigationItem.rightBarButtonItem = editButtonItem()
        drawSearchButton()
    }
    
    func searchButtonPressed(sender: UIBarButtonItem) {
        self.navigationItem.titleView = searchController.searchBar
        
        // TODO: enable toggling
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        
        searchController.searchBar.delegate = self
        searchController.searchBar.becomeFirstResponder()
    }
    
    func drawSearchButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(AllJotsController.searchButtonPressed(_:)))
    }

    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
    }
    
}
