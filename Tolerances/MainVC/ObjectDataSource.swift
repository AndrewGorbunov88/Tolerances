//
//  ObjectDataSource.swift
//  Tolerances
//
//  Created by Андрей Горбунов on 08.04.2021.
//

import UIKit

class ObjectDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private weak var parentVC: LinerDimensionsViewController?
    
    private static let cell = "Cell"
    private let sizeHeader: CGFloat = 40.0
    
    private var data = DataStore(with: .it12)
    
    init(vc: LinerDimensionsViewController) {
        self.parentVC = vc
    }
    
    func setToleranceInModel(with tolerance: ChosenTolerance) {
        data.setTolerance(tolerance: tolerance)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sizeHeader
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()

        vw.backgroundColor = AppDelegate.colorScheme.fillColor

        let labelForHeder = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: sizeHeader))
        labelForHeder.text = data.getStateToleranceValue.rawValue
        labelForHeder.font = UIFont(name: "Helvetica Neue Bold", size: 22)
        labelForHeder.textColor = AppDelegate.colorScheme.secondaryTextColor
        labelForHeder.textAlignment = .center
        labelForHeder.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint(item: labelForHeder, attribute: .centerX, relatedBy: .equal, toItem: vw, attribute: .centerX, multiplier: 1.0, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: labelForHeder, attribute: .centerY, relatedBy: .equal, toItem: vw, attribute: .centerY, multiplier: 1.0, constant: 0)
        
        
        vw.addSubview(labelForHeder)

        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])

        return vw
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.getAllDimensions
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: ObjectDataSource.cell) as? ItemCell

        if (cell == nil) {
            cell = UITableViewCell(style: .value1, reuseIdentifier: ObjectDataSource.cell) as? ItemCell
        }
        
        let textForCell = data.getElement(with: indexPath.row)
        let toleranceText = data.getToleranceValue(with: indexPath.row)
        
        cell?.setCell(with: textForCell, and: toleranceText, at: indexPath.row)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let toleranceValue = data.getValue(with: indexPath.row)
        parentVC!.toleranceValueTuple = toleranceValue
        
    }
    
    
}
