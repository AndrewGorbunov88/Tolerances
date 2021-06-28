//
//  HolePickerViewDataSource.swift
//  Tolerances
//
//  Created by Андрей Горбунов on 02.06.2021.
//

import UIKit

class HolePickerViewDataSource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    weak var parentHoleVC: HolesTolerancePickerViewController!
    
    private var componentWasSelected = 0
    
    init(vc: HolesTolerancePickerViewController, state: Int) {
        self.parentHoleVC = vc
        self.componentWasSelected = state
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return parentHoleVC.holeModel.getFieldsCountForPickerView
        } else {
            return parentHoleVC.holeModel.getToleranceCountForPickerView
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let rowColor = AppDelegate.colorScheme.primaryTextColor
        
        var resultString = String()
        
        switch component {
        case 0:
            resultString = parentHoleVC.holeModel.getFieldNameForRowsInPickerView(with: row)
        case 1:
            resultString = parentHoleVC.holeModel.getTolerancesNameForRowsInPickerView(with: row)
            
        default: break
        }
        
        let attributedString = NSAttributedString(string: resultString, attributes: [NSAttributedString.Key.foregroundColor : rowColor ?? .green])
        
        return attributedString
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        switch component {
        case 0:
            parentHoleVC.holeModel.setHoleOrShaftFieldForTable(at: row, and: componentWasSelected)
            pickerView.reloadComponent(1)
        case 1:
            parentHoleVC.holeModel.setDimensionsHolesOrShaftsForTable(at: row)
            componentWasSelected = row
        default: break
        }
        
    }

}
