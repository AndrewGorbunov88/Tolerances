//
//  SearchHoleController.swift
//  Tolerances
//
//  Created by Андрей Горбунов on 07.07.2021.
//

import UIKit

class SearchHoleAndShaftController: NSObject, UISearchBarDelegate {

    weak var searchBar: UISearchBar?
    weak var parentTableView: UITableView?
    weak var data: DataHolesAndShafts?
    
    private var findIn: UserSearchingDimension?
    
    init(bar: UISearchBar, find inModel: DataHolesAndShafts, tableForRefresh: UITableView) {
        self.searchBar = bar
        self.data = inModel
        self.parentTableView = tableForRefresh
        self.findIn = data
    }
    
    //MARK: - UISearchBarDelegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.findIn?.tolerance(in: searchBar.text!)
        self.parentTableView!.reloadData()
    }
    
}
