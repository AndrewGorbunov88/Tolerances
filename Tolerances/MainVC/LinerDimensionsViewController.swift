//
//  ViewController.swift
//  Tolerances
//
//  Created by Андрей Горбунов on 08.04.2021.
//

import UIKit

class LinerDimensionsViewController: UITableViewController, UISearchBarDelegate , IViewController {
    
    private var stateToleranceForInitPickerViewController: ChosenTolerance?
    
    @IBOutlet weak var linerSearchBar: UISearchBar! {
        didSet {
            self.linerSearchBar.setShowsCancelButton(false, animated: false)
            self.linerSearchBar.barTintColor = AppDelegate.colorScheme.barColor
        }
    }
    
    private var dataSourceAndDelegate: ObjectDataSource?
    private var searchBarDelegate: SearchController?
    
    var toleranceValueTuple: (tolerance: Double, symbol: String)? {
        didSet {
            
            guard let tolerance = toleranceValueTuple?.tolerance else { return }
            guard let symbol = toleranceValueTuple?.symbol else { return }
            
            let show = ShowTolerance()
            show.display(tolerance: tolerance, symbol: symbol, presenter: self)
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = ObjectDataSource(vc: self)
        dataSourceAndDelegate = data
        tableView.dataSource = dataSourceAndDelegate
        tableView.delegate = dataSourceAndDelegate
        
        let search = SearchController(bar: self.linerSearchBar,
                                      findIn: dataSourceAndDelegate!.data,
                                      tableForRefresh: self.tableView)
        searchBarDelegate = search
        self.linerSearchBar.delegate = searchBarDelegate
        
        createToleranceDidChangeObserver()
        createLeftButton()
        
        self.navigationController?.navigationBar.barTintColor = AppDelegate.colorScheme.barColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue Bold", size: 20.0)!,
                                                                        NSAttributedString.Key.foregroundColor: AppDelegate.colorScheme.secondaryTextColor!]
        
        self.tableView.keyboardDismissMode = .onDrag
        
        self.tableView.setContentOffset(CGPoint(x: 0, y: 56), animated: false)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func pickTolerance() {
        let tolerancePickerView = storyboard?.instantiateViewController(identifier: "TolerancePickerViewController") as! TolerancePickerViewController
        tolerancePickerView.modalPresentationStyle = .custom
        tolerancePickerView.transitioningDelegate = self
        tolerancePickerView.delegate = self
        
        if let sendToleranceState = stateToleranceForInitPickerViewController {
            tolerancePickerView.setStateTolerance(chosen: sendToleranceState)
        }
        
        present(tolerancePickerView, animated: true, completion: nil)
    }
    
    @objc func tableViewRefresh(notification: Notification) {
        
        if let modelStateWasRefreshed = notification.userInfo![Notification.Name.didToleranceChange] as? ChosenTolerance {
            
            let newToleranceSet = modelStateWasRefreshed
            stateToleranceForInitPickerViewController = newToleranceSet
            
        }
        
        tableView.reloadData()
    }
    
    private func createToleranceDidChangeObserver() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(tableViewRefresh), name: .didToleranceChange, object: nil)
    }
    
    private func createLeftButton() {
        let chooseToleranceButton = { () -> UIBarButtonItem in
            let button: UIBarButtonItem
            button = UIBarButtonItem(title: "Квалитеты", style: .done, target: self, action: #selector(pickTolerance))
            button.tintColor = AppDelegate.colorScheme.buttonColor
            
            return button
        }()
        
        self.navigationItem.leftBarButtonItem = chooseToleranceButton
    }
        
}

extension LinerDimensionsViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension LinerDimensionsViewController: SetTolerance {
    func sendTolerance(_ sender: ChosenTolerance) {
        dataSourceAndDelegate!.setToleranceInModel(with: sender)
    }
    
}

protocol UserSearchingDimension {
    func tolerance(in size: String)
}

enum ChosenTolerance: String, CaseIterable {
    case it01 = "IT01"
    case it0 = "IT0"
    case it1 = "IT1"
    case it2 = "IT2"
    case it3 = "IT3"
    case it4 = "IT4"
    case it5 = "IT5"
    case it6 = "IT6"
    case it7 = "IT7"
    case it8 = "IT8"
    case it9 = "IT9"
    case it10 = "IT10"
    case it11 = "IT11"
    case it12 = "IT12"
    case it13 = "IT13"
    case it14 = "IT14"
    case it15 = "IT15"
    case it16 = "IT16"
    case it17 = "IT17"
    case it18 = "IT18"
}
