//
//  PickerViewDataSourceDelegate.swift
//  Tolerances
//
//  Created by Андрей Горбунов on 06.05.2021.
//

import UIKit

class PickerViewDataSourceDelegate: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    weak var parentPickerViewVC: TolerancePickerViewController?
    
    init(vc parent: TolerancePickerViewController) {
        self.parentPickerViewVC = parent
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ChosenTolerance.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let rowColor = AppDelegate.colorScheme.primaryTextColor
        
        let toleranceString = ChosenTolerance.allCases[row].rawValue
        let attributedString = NSAttributedString(string: toleranceString, attributes: [NSAttributedString.Key.foregroundColor : rowColor ?? .green])
        
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedTolerance = ChosenTolerance.allCases[row]
        parentPickerViewVC?.setStateTolerance(chosen: selectedTolerance)
    }

}
