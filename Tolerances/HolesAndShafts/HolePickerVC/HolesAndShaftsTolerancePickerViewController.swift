//
//  HolesTolerancePickerViewController.swift
//  Tolerances
//
//  Created by Андрей Горбунов on 01.06.2021.
//

import UIKit
import CoreData

protocol SendToleranceNameInTextField {
    func sendChosenTolerance(_ text: String, in field: Fields)
}

class HolesAndShaftsTolerancePickerViewController: UIViewController {
    
    enum FitState {
        case fit
        case dontFit
    }
    
    private var state: Fields?
    
    var toleranceDelegate: SendToleranceNameInTextField?
    lazy var fittingState: FitState = .dontFit
    
    private var stateHoleField: Fields?
    private var stateDimension: Int?
    private var chosenTolerance: String?
    
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
            self.stateHoleField = holeAndShaftModel.getChoseState as! HoleFields
            self.stateDimension = holeAndShaftModel.getDimensionState
        }
        
        if state is ShaftFields {
            self.stateHoleField = holeAndShaftModel.getChoseState as! ShaftFields
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
        
        if fittingState == .dontFit {
            self.saveHoleOrShaftInData()
        }
        
        if fittingState == .fit {
            
            let senderString = holeAndShaftModel.getDefaultNameForHeader()
            self.saveHoleOrShaftInData()
            
            self.toleranceDelegate?.sendChosenTolerance(senderString, in: state!)
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    private func saveHoleOrShaftInData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //TODO: - реализовать DRY
        if fittingState == .dontFit {
            
            let request = NSFetchRequest<MemoryTolerance>(entityName: "MemoryTolerance")
            
            do {
                let resultArray = try context.fetch(request)
                
                if state is HoleFields {
                    
                    resultArray.first?.holeField = (holeAndShaftModel.getChoseState as! HoleFields).rawValue
                    resultArray.first?.holeState = Int16(holeAndShaftModel.getDimensionState)
                    
                }
                
                if state is ShaftFields {
                    resultArray.first?.shaftField = (holeAndShaftModel.getChoseState as! ShaftFields).rawValue
                    resultArray.first?.shaftState = Int16(holeAndShaftModel.getDimensionState)
                }
                
                try context.save()
            } catch {
                print("Error")
            }
            
        }
        
        if fittingState == .fit {
            
            let request = NSFetchRequest<MemoryFitTolerance>(entityName: "MemoryFitTolerance")
            
            do {
                let resultArray = try context.fetch(request)
                
                if state is HoleFields {
                    
                    resultArray.first?.fitHoleField = (holeAndShaftModel.getChoseState as! HoleFields).rawValue
                    resultArray.first?.fitHoleState = Int16(holeAndShaftModel.getDimensionState)
                    
                }
                
                if state is ShaftFields {
                    resultArray.first?.fitShaftField = (holeAndShaftModel.getChoseState as! ShaftFields).rawValue
                    resultArray.first?.fitShaftState = Int16(holeAndShaftModel.getDimensionState)
                }
                
                try context.save()
            } catch {
                print("Error")
            }
        }
        
        
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
