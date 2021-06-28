//
//  HolesVCDataSource.swift
//  Tolerances
//
//  Created by Андрей Горбунов on 25.05.2021.
//

import UIKit

class HolesOrShaftsVCDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private weak var parentHolesVC: UITableViewController?
    
    private let sizeHeader: CGFloat = 40.0
    
    init(vc: HolesOrShaftsVC) {
        
        if vc is HolesViewController {
            self.parentHolesVC = (vc as? HolesViewController)
        }
        
        if vc is ShaftsViewController {
            self.parentHolesVC = (vc as? ShaftsViewController)
        }
        
    }
    
    //MARK: - UITableViewDataSource
    
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
        labelForHeder.text = (parentHolesVC as! HolesOrShaftsVC).dataHolesModel.getDefaultNameForHeader()
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
        return (parentHolesVC! as! HolesOrShaftsVC).dataHolesModel.getTolerancesCountForCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "Hole Tolerances") as? HoleOrShaftCell

        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Hole Tolerances") as? HoleOrShaftCell
        }
        
        let tolerancesData = (parentHolesVC as! HolesOrShaftsVC).dataHolesModel.getDataForCell(at: indexPath.row)
        let name = (parentHolesVC as! HolesOrShaftsVC).dataHolesModel.getNameTolerances(at: indexPath.row)

        cell!.esLabel.text = checkSign(in: tolerancesData.es, and: tolerancesData.unit)
        cell!.eiLabel.text = checkSign(in: tolerancesData.ei, and: tolerancesData.unit)

        cell!.nameForCell.text = name
            
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Methods
    
    func checkSign(in value: Double?, and unit: UnitLength?) -> String {
        var text = String()
        
        guard let value = value else { return "" }
        guard let unit = unit?.symbol else { return "" }
        
        text = String(value)
        
        if text.first != "-" && text != "0.0" {
            text.insert(contentsOf: "+", at: text.startIndex)
        }
        
        text += " " + unit
        
        return text
    }
    
}
