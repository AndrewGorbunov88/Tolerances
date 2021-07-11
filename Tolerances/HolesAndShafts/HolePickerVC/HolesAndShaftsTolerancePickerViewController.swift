//
//  HolesTolerancePickerViewController.swift
//  Tolerances
//
//  Created by Андрей Горбунов on 01.06.2021.
//

import UIKit

class HolesAndShaftsTolerancePickerViewController: UIViewController {
    
    private var state: Fields?
    
    private var stateHoleField: Fields?
//    private var stateHoleField: HoleFields = .h
    private var stateDimension: Int?
    
    weak var holeAndShaftModel: DataHolesAndShafts!
    
    private var pickerHoleDataSourceDelegate: HoleAndShaftPickerViewDataSource?
    
    @IBOutlet weak var holeCancelButton: UIBarButtonItem! {
        didSet {
            holeCancelButton.tintColor = AppDelegate.colorScheme.buttonColor ?? .orange
        }
    }
    
    @IBOutlet weak var holeSelectButton: UIBarButtonItem! {
        didSet {
            holeSelectButton.tintColor = AppDelegate.colorScheme.buttonColor ?? .orange
        }
    }
    
    @IBOutlet weak var holeToolBar: UIToolbar! {
        didSet {
            holeToolBar.barTintColor = AppDelegate.colorScheme.fillColor
        }
    }
    
    @IBOutlet weak var holeTolerancePickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if state is HoleFields {
            self.stateHoleField = holeAndShaftModel.getChooseState as! HoleFields
            self.stateDimension = holeAndShaftModel.getDimensionState
        }
        
        if state is ShaftFields {
            self.stateHoleField = holeAndShaftModel.getChooseState as! ShaftFields
            self.stateDimension = holeAndShaftModel.getDimensionState
        }
        
        
        let holePickerControl = HoleAndShaftPickerViewDataSource(vc: self, state: stateDimension!)
        pickerHoleDataSourceDelegate = holePickerControl
        
        holeTolerancePickerView.dataSource = pickerHoleDataSourceDelegate
        holeTolerancePickerView.delegate = pickerHoleDataSourceDelegate
        
        setDefaultRowHoleFieldOfPickerView()
           
    }
    
    deinit {
        self.holeAndShaftModel.clearBuffers()
    }

    @IBAction func cancelHolePickerViewAction(_ sender: Any) {
        self.holeAndShaftModel.setAllDimensionsFromBuffers()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectHolePickerViewAction(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    private func setDefaultRowHoleFieldOfPickerView() {
        
        if stateHoleField is HoleFields {
            for index in 0..<HoleFields.allCases.count {
                if HoleFields.allCases[index] == (stateHoleField as! HoleFields) {
                    self.holeTolerancePickerView.selectRow(index, inComponent: 0, animated: true)
                    self.holeTolerancePickerView.selectRow(stateDimension!, inComponent: 1, animated: true)
                }
            }
        }
        
        if stateHoleField is ShaftFields {
            for index in 0..<ShaftFields.allCases.count {
                if ShaftFields.allCases[index] == (stateHoleField as! ShaftFields) {
                    self.holeTolerancePickerView.selectRow(index, inComponent: 0, animated: true)
                    self.holeTolerancePickerView.selectRow(stateDimension!, inComponent: 1, animated: true)
                }
            }
        }
        
    }
    
    func set(state: Fields) {
        self.state = state
    }
}