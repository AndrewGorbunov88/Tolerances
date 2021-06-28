//
//  TolerancePickerViewController.swift
//  Tolerances
//
//  Created by Андрей Горбунов on 20.04.2021.
//

import UIKit

class TolerancePickerViewController: UIViewController {
    
    private var stateTolerance: ChosenTolerance? = .it12
        
    var delegate: SetTolerance?
    
    private var pickerDataSourceDelegate: PickerViewDataSourceDelegate?
    
    @IBOutlet weak var toolBar: UIToolbar! {
        didSet {
            toolBar.barTintColor = AppDelegate.colorScheme.fillColor
        }
    }
    
    @IBOutlet weak var cancelButton: UIBarButtonItem! {
        didSet {
            cancelButton.tintColor = AppDelegate.colorScheme.buttonColor ?? .orange
        }
    }
    
    @IBOutlet weak var selectToleranceButton: UIBarButtonItem! {
        didSet {
            selectToleranceButton.tintColor = AppDelegate.colorScheme.buttonColor ?? .orange
        }
    }
    
    @IBOutlet weak var tolerancePickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let pickerControl = PickerViewDataSourceDelegate(vc: self)
        pickerDataSourceDelegate = pickerControl
        
        tolerancePickerView.delegate = pickerDataSourceDelegate
        tolerancePickerView.dataSource = pickerDataSourceDelegate
        
        setDefaultRowOfPickerView(item: stateTolerance!)
        
    }
    
    @IBAction func cancelButtonAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectButtonAction(_ sender: Any) {
        if let senderTolerance = stateTolerance {
            self.delegate?.sendTolerance(senderTolerance)            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func refreshTolerance(notification: Notification) {
        if let modelStateWasRefreshed = notification.userInfo![Notification.Name.didToleranceChange] as? ChosenTolerance {
            
            let newToleranceSet = modelStateWasRefreshed
            stateTolerance = newToleranceSet
            
        }
    }
    
    private func setDefaultRowOfPickerView(item: ChosenTolerance) {
        if stateTolerance == nil {
            stateTolerance = item
        }
        
        let arrayTolerancesFromEnum = ChosenTolerance.allCases
        for indexOfEnum in 0..<ChosenTolerance.allCases.count {
            if arrayTolerancesFromEnum[indexOfEnum] == item {
                self.tolerancePickerView.selectRow(indexOfEnum, inComponent: 0, animated: true)
            }
        }
        
    }
    
    func setStateTolerance(chosen: ChosenTolerance) {
        stateTolerance = chosen
    }
    
}

protocol SetTolerance {
    func sendTolerance(_ sender : ChosenTolerance)
}
