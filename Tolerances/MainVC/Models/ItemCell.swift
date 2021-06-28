//
//  ItemCell.swift
//  Tolerances
//
//  Created by Андрей Горбунов on 11.04.2021.
//

import UIKit

class ItemCell: UITableViewCell {
    
    func setCell(with primaryText: String, and secondaryText: String, at index: Int) {
        
        let sizeFont: CGFloat = 18.0
        let fontName = "Helvetica Neue"
        
        self.contentConfiguration = { () -> UIListContentConfiguration in
            var attributes = self.defaultContentConfiguration()
            attributes.prefersSideBySideTextAndSecondaryText = true
            attributes.text = primaryText
            attributes.textProperties.font = UIFont(name: fontName, size: sizeFont)!
            
            attributes.secondaryText = secondaryText
            attributes.secondaryTextProperties.font = UIFont(name: fontName, size: sizeFont)!
            
            attributes.textProperties.color = AppDelegate.colorScheme.primaryTextColor ?? .gray
            attributes.secondaryTextProperties.color = AppDelegate.colorScheme.primaryTextColor ?? .darkGray
            
            return attributes
        }()
    }

}
