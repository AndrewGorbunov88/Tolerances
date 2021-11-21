//
//  FitViewController.swift
//  Tolerances
//
//  Created by Андрей Горбунов on 18.10.2021.
//

import UIKit

class FitViewController: UIViewController, UITextFieldDelegate {
    
    private var dataHolesModel = DataHolesAndShafts(choseFieldState: FieldState.hole, forFitting: true)
    private var dataShaftsModel = DataHolesAndShafts(choseFieldState: FieldState.shaft, forFitting: true)
    private var brainModel = FittingBrain()
    
    private var searchHoles: UserSearchingDimension?
    private var searchShafts: UserSearchingDimension?
    
    @IBOutlet weak var calculateButton: UIButton!
    
    @IBOutlet var namesLabel: [UILabel]!
    
    @IBOutlet weak var diameterField: UITextField! {
        didSet {
            diameterField.tintColor = AppDelegate.colorScheme.barColor
            diameterField.textColor = AppDelegate.colorScheme.buttonColor
            diameterField.keyboardType = .numbersAndPunctuation
            diameterField.delegate = self
        }
    }
    
    @IBOutlet weak var holeField: UITextField! {
        didSet {
            holeField.tintColor = AppDelegate.colorScheme.barColor
            holeField.textColor = AppDelegate.colorScheme.buttonColor
            holeField.delegate = self
            holeField.text = dataHolesModel.getDefaultNameForHeader()
        }
    }
    
    @IBOutlet weak var shaftField: UITextField! {
        didSet {
            shaftField.tintColor = AppDelegate.colorScheme.barColor
            shaftField.textColor = AppDelegate.colorScheme.buttonColor
            shaftField.delegate = self
            shaftField.text = dataShaftsModel.getDefaultNameForHeader()
        }
    }
    
    @IBOutlet weak var dMaxHoleLabel: UILabel! {
        didSet {
            settingsLabel(in: dMaxHoleLabel, with: "Helvetica Neue", withDefaultText: "-")
        }
    }
    
    @IBOutlet weak var dMinHoleLabel: UILabel! {
        didSet {
            settingsLabel(in: dMinHoleLabel, with: "Helvetica Neue", withDefaultText: "-")
        }
    }
    
    @IBOutlet weak var dMaxShaftLabel: UILabel! {
        didSet {
            settingsLabel(in: dMaxShaftLabel, with: "Helvetica Neue", withDefaultText: "-")
        }
    }
    
    @IBOutlet weak var dMinShaftLabel: UILabel! {
        didSet {
            settingsLabel(in: dMinShaftLabel, with: "Helvetica Neue", withDefaultText: "-")
        }
    }
    
    @IBOutlet weak var sMaxLabel: UILabel!
    @IBOutlet weak var sMinLabel: UILabel!
    
    @IBOutlet weak var sMaxResultLabel: UILabel! {
        didSet {
            settingsLabel(in: sMaxResultLabel, with: "Helvetica Neue", withDefaultText: "-")
        }
    }
    
    @IBOutlet weak var sMinResultLabel: UILabel! {
        didSet {
            settingsLabel(in: sMinResultLabel, with: "Helvetica Neue", withDefaultText: "-")
        }
    }
    
    @IBOutlet weak var resultFittingLabel: UILabel! {
        didSet {
            settingsLabel(in: resultFittingLabel, with: "Helvetica Neue Bold", withDefaultText: "-")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchHoles = dataHolesModel
        self.searchShafts = dataShaftsModel
        
        for label in namesLabel {
            settingsLabel(in: label, with: "Helvetica Neue", withDefaultText: label.text!)
        }
        
        self.view.backgroundColor = AppDelegate.colorScheme.barColor

        self.navigationController?.navigationBar.barTintColor = AppDelegate.colorScheme.barColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue Bold", size: 20.0)!,
                                                                        NSAttributedString.Key.foregroundColor: AppDelegate.colorScheme.secondaryTextColor!]
        
    }
    
    //MARK: - Action
    @IBAction func calculateAction(_ sender: UIButton) {
        if diameterField.text == "" {
            //TODO: - реализовать AlertController
        } else {
            searchHoles?.tolerance(in: diameterField.text!)
            searchShafts?.tolerance(in: diameterField.text!)
            let localValuesOfHole = dataHolesModel.getDataForCell(at: 0)
            let localValuesOfShaft = dataShaftsModel.getDataForCell(at: 0)
            
            if let diameterValue = Double(self.diameterField.text!) {
                self.brainModel.setValues(diameterValue: diameterValue,
                                           esHole: localValuesOfHole.es!,
                                           eiHole: localValuesOfHole.ei!,
                                           holeUnit: localValuesOfHole.unit!,
                                           esShaft: localValuesOfShaft.es!,
                                           eiShaft: localValuesOfShaft.ei!,
                                           shaftUnit: localValuesOfShaft.unit!)
                
                self.dMaxHoleLabel.text = brainModel.getResult(for: .dMaxHole)
                self.dMinHoleLabel.text = brainModel.getResult(for: .dMinHole)
                self.dMaxShaftLabel.text = brainModel.getResult(for: .dMaxShaft)
                self.dMinShaftLabel.text = brainModel.getResult(for: .dMinShaft)
                
                self.sMaxResultLabel.text = brainModel.getResult(for: .sMax)
                self.sMinResultLabel.text = brainModel.getResult(for: .sMin)
                
                self.resultFittingLabel.text = brainModel.getFitResult()
                
                if self.resultFittingLabel.text == FittingResult.clearanceFit.rawValue {
                    self.sMaxLabel.text = "Smax:"
                    self.sMinLabel.text = "Smin:"
                }
                
                if self.resultFittingLabel.text == FittingResult.pressFit.rawValue {
                    self.sMaxLabel.text = "Nmax:"
                    self.sMinLabel.text = "Nmin:"
                }
                
                if self.resultFittingLabel.text == FittingResult.transitionFit.rawValue {
                    self.sMaxLabel.text = "Smax:"
                    self.sMinLabel.text = "Nmax:"
                }
                
            }
                        
        }
    }
    
    //MARK: - Methods
    private func callHoleOrShaftPicker(identifier: String, state: Fields, model: DataHolesAndShafts) {
        
        let callPicker = storyboard?.instantiateViewController(withIdentifier: identifier) as! HolesAndShaftsTolerancePickerViewController
        callPicker.modalPresentationStyle = .custom
        callPicker.transitioningDelegate = self
        callPicker.toleranceDelegate = self
        callPicker.set(state: state as Fields)
        callPicker.holeAndShaftModel = model
        callPicker.holeAndShaftModel.setBuffers()
        callPicker.fittingState = .fit
        
        present(callPicker, animated: true, completion: nil)
        
    }
    
    private func settingsLabel(in label: UILabel, with fontName: String, withDefaultText text: String) {
        label.textColor = AppDelegate.colorScheme.secondaryTextColor
        label.font = UIFont(name: fontName, size: 20)
        label.text = text
    }
    
    //MARK: - UITextFieldDelegate and UITextFieldDataSource
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.isEqual(holeField) {
            
            callHoleOrShaftPicker(identifier: "HolesAndShaftsTolerancePickerViewController", state: HoleFields.h, model: dataHolesModel)
            
            return false
            
        } else if textField.isEqual(shaftField) {
            
            callHoleOrShaftPicker(identifier: "HolesAndShaftsTolerancePickerViewController", state: ShaftFields.h, model: dataShaftsModel)
            
            return false
            
        } else {
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }

        let newText = oldText.replacingCharacters(in: r, with: string)

        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1

        var numberOfDecimalDigits: Int
        if let dotIndex = newText.firstIndex(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }

        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.last == "." {
            textField.text?.removeLast()
        }
        textField.resignFirstResponder()
        
        return true
    }

}

extension FitViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension FitViewController: SendToleranceNameInTextField {
    
    func sendChosenTolerance(_ text: String, in field: Fields) {
        
        if field is HoleFields {
            self.holeField.text = text
        }
        
        if field is ShaftFields {
            self.shaftField.text = text
        }
        
    }
    
}
