//
//  ColorSchemes.swift
//  Tolerances
//
//  Created by Андрей Горбунов on 06.05.2021.
//

import UIKit

class ColorSchemes: NSObject {

    var primaryTextColor: UIColor?
    var secondaryTextColor: UIColor?
    var fillColor: UIColor?
    var barColor: UIColor?
    var buttonColor: UIColor?
    var strokeColor: UIColor?
    
    func createColorModel() {
        
        primaryTextColor = UIColor(red: 160/255.0, green: 148/255.0, blue: 138/255.0, alpha: 1.0)
        secondaryTextColor = UIColor(red: 105/255.0, green: 98/255.0, blue: 90/255.0, alpha: 1.0)
        fillColor = UIColor(red: 231/255.0, green: 227/255.0, blue: 220/255.0, alpha: 1.0)
        barColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        buttonColor = UIColor(red: 102/255.0, green: 62/255.0, blue: 29/255.0, alpha: 1.0)
        strokeColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
    }
    
}
