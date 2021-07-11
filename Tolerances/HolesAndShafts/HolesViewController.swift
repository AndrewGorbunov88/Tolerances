//
//  HolesViewController.swift
//  Tolerances
//
//  Created by Андрей Горбунов on 25.05.2021.
//

import UIKit

class HolesViewController: UITableViewController, HolesOrShaftsVC {
    
    @IBOutlet weak var holesSearchBar: UISearchBar! {
        didSet {
            self.holesSearchBar.setShowsCancelButton(false, animated: false)
            self.holesSearchBar.barTintColor = AppDelegate.colorScheme.barColor
        }
    }
    
    var holesDataSource: HolesOrShaftsVCDataSource?
    var searchHoleController: SearchController?

    var dataHolesModel = DataHolesAndShafts(choseFieldState: HoleFields.h)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let holesData = HolesOrShaftsVCDataSource(vc: self)
        holesDataSource = holesData

        self.tableView.dataSource = holesDataSource
        self.tableView.delegate = holesDataSource
        
        let searchHole = SearchController(bar: self.holesSearchBar,
                                          findIn: dataHolesModel,
                                          tableForRefresh: self.tableView)
        searchHoleController = searchHole
        self.holesSearchBar.delegate = searchHoleController

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
            holeButton = UIBarButtonItem(title: "Поля отв.", style: .done, target: self, action: #selector(pickHoleField))
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
        let holeTolerancePickerView = storyboard?.instantiateViewController(identifier: "HolesTolerancePickerViewController") as! HolesTolerancePickerViewController
        holeTolerancePickerView.modalPresentationStyle = .custom
        holeTolerancePickerView.transitioningDelegate = self
        holeTolerancePickerView.set(state: HoleFields.h as Fields)
        holeTolerancePickerView.holeModel = dataHolesModel
        holeTolerancePickerView.holeModel.setBuffers()

        present(holeTolerancePickerView, animated: true, completion: nil)
    }

}

extension HolesViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}

protocol HolesOrShaftsVC {
    var dataHolesModel: DataHolesAndShafts { get set }
}
