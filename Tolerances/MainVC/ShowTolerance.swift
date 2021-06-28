//
//  ShowTolerance.swift
//  Tolerances
//
//  Created by Андрей Горбунов on 06.05.2021.
//

import UIKit

// for MOCK
protocol IViewController {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}

class ShowTolerance: NSObject {

    private let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    
    func display(tolerance: Double, symbol: String, presenter: IViewController) {
        
        let titleTolerance = "Точность \(tolerance) \(symbol)"
        let titleToleranceDivided = "± \(tolerance / 2) \(symbol)"
        
        let titleParameters = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 20.0),
                               NSAttributedString.Key.foregroundColor: AppDelegate.colorScheme.secondaryTextColor]
        
        let titleAttributedString = NSMutableAttributedString(string: titleTolerance, attributes: titleParameters as [NSAttributedString.Key : Any])

        let messageParameters = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 18.0),
                                 NSAttributedString.Key.foregroundColor: AppDelegate.colorScheme.secondaryTextColor]
        
        let messageAttributedString = NSMutableAttributedString(string: titleToleranceDivided, attributes: messageParameters as [NSAttributedString.Key : Any])

        alertController.setValue(titleAttributedString, forKey: "attributedTitle")
        alertController.setValue(messageAttributedString, forKey: "attributedMessage")
        
        let actionButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        actionButton.setValue(AppDelegate.colorScheme.secondaryTextColor, forKey: "titleTextColor")
        
        alertController.addAction(actionButton)
        

        presenter.present(alertController, animated: true, completion: nil)
        
    }
    
}
