//
//  FirstCell.swift
//  Tolerances
//
//  Created by Андрей Горбунов on 19.06.2021.
//

import UIKit

class FirstCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func setHeaderCell(with primaryText: String, and secondaryText: String, at index: Int) {
        
        let sizeFont: CGFloat = 20.0
        let fontName = "Helvetica Neue"
        
        self.contentConfiguration = { () -> UIListContentConfiguration in
            var attributes = self.defaultContentConfiguration()
            attributes.prefersSideBySideTextAndSecondaryText = true
            attributes.text = primaryText
            attributes.textProperties.font = UIFont(name: fontName, size: sizeFont)!
            
            attributes.secondaryText = secondaryText
            attributes.secondaryTextProperties.font = UIFont(name: fontName, size: sizeFont)!
            
            if index == 0 {
                attributes.textProperties.color = AppDelegate.colorScheme.secondaryTextColor ?? .green
                attributes.secondaryTextProperties.color = AppDelegate.colorScheme.secondaryTextColor ?? .green
            } else {
                attributes.textProperties.color = AppDelegate.colorScheme.primaryTextColor ?? .gray
                attributes.secondaryTextProperties.color = AppDelegate.colorScheme.primaryTextColor ?? .darkGray
            }
            
            return attributes
        }()
        
    }

}
