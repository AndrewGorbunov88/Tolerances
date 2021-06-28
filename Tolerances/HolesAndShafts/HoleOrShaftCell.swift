//
//  HoleCell.swift
//  Tolerances
//
//  Created by Андрей Горбунов on 25.05.2021.
//

import UIKit

class HoleOrShaftCell: UITableViewCell {
    
    @IBOutlet weak var nameForCell: UILabel! {
        didSet{
            nameForCell.textColor = AppDelegate.colorScheme.primaryTextColor ?? .gray
        }
    }
    
    @IBOutlet weak var esLabel: UILabel! {
        didSet {
            esLabel.textColor = AppDelegate.colorScheme.primaryTextColor ?? .darkGray
        }
    }
    
    @IBOutlet weak var eiLabel: UILabel! {
        didSet {
            eiLabel.textColor = AppDelegate.colorScheme.primaryTextColor ?? .darkGray
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
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
