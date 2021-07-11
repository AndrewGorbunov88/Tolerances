//
//  HolePickerViewDataSource.swift
//  Tolerances
//
//  Created by Андрей Горбунов on 02.06.2021.
//

import UIKit

class HoleAndShaftPickerViewDataSource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    weak var parentHoleVC: HolesAndShaftsTolerancePickerViewController!
    
    private var componentWasSelected = 0
    
    init(vc: HolesAndShaftsTolerancePickerViewController, state: Int) {
        self.parentHoleVC = vc
        self.componentWasSelected = state
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return parentHoleVC.holeAndShaftModel.getFieldsCountForPickerView
        } else {
            return parentHoleVC.holeAndShaftModel.getToleranceCountForPickerView
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let rowColor = AppDelegate.colorScheme.primaryTextColor
        
        var resultString = String()
        
        switch component {
        case 0:
            resultString = parentHoleVC.holeAndShaftModel.getFieldNameForRowsInPickerView(with: row)
        case 1:
            resultString = parentHoleVC.holeAndShaftModel.getTolerancesNameForRowsInPickerView(with: row)
            
        default: break
        }
        
        let attributedString = NSAttributedString(string: resultString, attributes: [NSAttributedString.Key.foregroundColor : rowColor ?? .green])
        
        return attributedString
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        switch component {
        case 0:
            parentHoleVC.holeAndShaftModel.setHoleOrShaftFieldForTable(at: row, and: componentWasSelected)
            pickerView.reloadComponent(1)
        case 1:
            parentHoleVC.holeAndShaftModel.setDimensionsHolesOrShaftsForTable(at: row)
            componentWasSelected = row
        default: break
        }
        
    }

}
