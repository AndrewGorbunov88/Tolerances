//
//  Search.swift
//  Tolerances
//
//  Created by Андрей Горбунов on 06.07.2021.
//

import UIKit

class SearchController: NSObject, UISearchBarDelegate {

    private weak var searchBar: UISearchBar?
    private weak var parentTableView: UITableView?
    
    private var findIn: UserSearchingDimension?    
    
    init(bar: UISearchBar, findIn inModel: UserSearchingDimension, tableForRefresh: UITableView) {
        self.searchBar = bar
        self.findIn = inModel
        self.parentTableView = tableForRefresh
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
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let digitsSet = CharacterSet.decimalDigits.inverted
        let components = text.components(separatedBy: digitsSet)
        let filteredString = components.joined(separator: "")
        
        if filteredString == text {
            return true
        } else {
            if text == "." || text == "," {
                let countDots = searchBar.text!.components(separatedBy:".").count - 1
                let countCommas = searchBar.text!.components(separatedBy:",").count - 1
                
                if countDots == 0 && countCommas == 0 {
                    return true
                } else {
                    return false
                }
            } else  {
                return false
            }
        }
        
    }
    
}
