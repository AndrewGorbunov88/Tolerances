//
//  HalfSizePresentationController.swift
//  Tolerances
//
//  Created by Андрей Горбунов on 06.05.2021.
//

import UIKit

class HalfSizePresentationController: UIPresentationController {
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(x: 0, y: (containerView?.bounds.height)!/2, width: (containerView?.bounds.width)!, height: (containerView?.bounds.height)!/2)
    }
}
