//
//  ShowToleranceTests.swift
//  TolerancesTests
//
//  Created by Андрей Горбунов on 08.05.2021.
//

@testable import Tolerances
import XCTest

class Mock: IViewController {
    var testAlert = UIAlertController(title: "", message: "", preferredStyle: .alert)
    
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        testAlert = viewControllerToPresent as! UIAlertController
    }
    
}

class ShowToleranceTests: XCTestCase {

    var showTolerance: ShowTolerance!
    
    override func setUp() {
        super.setUp()
        showTolerance = ShowTolerance()
    }
    
    override func tearDown() {
        showTolerance = nil
        super.tearDown()
    }
    
    func test_displayMethod() {
        let testToleranceValue = 0.1
        let testSymbol = "mm"
        let mockVC = Mock()
        
        let checkToleranceValue = "Точность 0.1 mm"
        let checkToleranceDivided = "± 0.05 mm"
        
        showTolerance.display(tolerance: testToleranceValue, symbol: testSymbol, presenter: mockVC)
        
        let alertTitle = (mockVC.testAlert.value(forKey: "attributedTitle") as? NSAttributedString)?.string
        
        let alertMessageTitle = (mockVC.testAlert.value(forKey: "attributedMessage") as? NSAttributedString)?.string
        
        XCTAssertEqual(alertTitle, checkToleranceValue)
        XCTAssertEqual(alertMessageTitle, checkToleranceDivided)
        
    }

}
