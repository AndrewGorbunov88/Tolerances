//
//  ShaftsViewController.swift
//  Tolerances
//
//  Created by Андрей Горбунов on 16.06.2021.
//

import UIKit

class ShaftsViewController: UITableViewController, HolesOrShaftsVC {
    
    @IBOutlet weak var shaftsSearchBar: UISearchBar! {
        didSet {
            self.shaftsSearchBar.setShowsCancelButton(false, animated: false)
            self.shaftsSearchBar.barTintColor = AppDelegate.colorScheme.barColor
        }
    }
    
    var shaftDataSource: HolesOrShaftsVCDataSource?
    var searchShaftController: SearchController?

    var dataHolesModel = DataHolesAndShafts(choseFieldState: ShaftFields.h)

    override func viewDidLoad() {
        super.viewDidLoad()

        let shaftsData = HolesOrShaftsVCDataSource(vc: self)
        shaftDataSource = shaftsData

        self.tableView.dataSource = shaftDataSource
        self.tableView.delegate = shaftDataSource
        
        let searchShaft = SearchController(bar: self.shaftsSearchBar,
                                           findIn: dataHolesModel,
                                           tableForRefresh: self.tableView)
        searchShaftController = searchShaft
        self.shaftsSearchBar.delegate = searchShaftController

        createLeftButton()
        createHoleDimensionsDidChangeObserver()

        self.navigationController?.navigationBar.barTintColor = AppDelegate.colorScheme.barColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue Bold", size: 20.0)!,
                                                                        NSAttributedString.Key.foregroundColor: AppDelegate.colorScheme.secondaryTextColor!]

        self.tableView.keyboardDismissMode = .onDrag
        
        self.tableView.setContentOffset(CGPoint(x: 0, y: 56), animated: false)
        
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func createLeftButton() {
        let chooseHoleToleranceButton = { () -> UIBarButtonItem in
            let holeButton: UIBarButtonItem
            holeButton = UIBarButtonItem(title: "Поля валов.", style: .done, target: self, action: #selector(pickHoleField))
            holeButton.tintColor = AppDelegate.colorScheme.buttonColor

            return holeButton
        }()

        self.navigationItem.leftBarButtonItem = chooseHoleToleranceButton
    }

    private func createHoleDimensionsDidChangeObserver() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(tableViewHoleRefresh), name: .didHoleDimensionsChange, object: nil)
    }

    @objc private func tableViewHoleRefresh(notification: Notification) {

            tableView.reloadData()

    }

    @objc private func pickHoleField() {
        let holeTolerancePickerView = storyboard?.instantiateViewController(identifier: "HolesAndShaftsTolerancePickerViewController") as! HolesAndShaftsTolerancePickerViewController
        holeTolerancePickerView.modalPresentationStyle = .custom
        holeTolerancePickerView.transitioningDelegate = self
        holeTolerancePickerView.set(state: ShaftFields.h as Fields)
        holeTolerancePickerView.holeAndShaftModel = dataHolesModel
        holeTolerancePickerView.holeAndShaftModel.setBuffers()

        present(holeTolerancePickerView, animated: true, completion: nil)
    }

}

extension ShaftsViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}

