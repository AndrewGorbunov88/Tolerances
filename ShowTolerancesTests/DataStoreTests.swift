//
//  DataStoreTests.swift
//  TolerancesTests
//
//  Created by Андрей Горбунов on 16.05.2021.
//

@testable import Tolerances
import XCTest

class DataStoreTests: XCTestCase {
    
    var data: DataStore?
    let toleranceForInit: ChosenTolerance = .it12

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        data = nil
        super.tearDown()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Observer
    private func createToleranceDidChangeObserver() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(modelIsRefresh), name: .didToleranceChange, object: nil)
    }
    
    @objc private func modelIsRefresh(notification: Notification) {
        if let modelStateRefreshed = notification.userInfo![Notification.Name.didToleranceChange] as? ChosenTolerance {
            let newTolerance = modelStateRefreshed
            XCTAssertNotEqual(newTolerance, toleranceForInit)
        }
    }
    
    func test_getElement() {
        
        //TODO: - Заменить на массив, чтобы проверить соответствие всех элементов
        let checkString = "До 3"
        
        data = DataStore(with: toleranceForInit)
        
        let getResult = data?.getElement(with: 0)
        
        if let result = getResult {
            XCTAssertTrue(!result.isEmpty)
        }
        
        XCTAssertNotNil(getResult)
        XCTAssertEqual(getResult, checkString)
        
    }
    
    func test_getAllDimensions() {
        
        let countElementInTableMustGreater = 0
        let countElementInTableInFact = 25
        
        data = DataStore(with: toleranceForInit)
        
        if let countElementsResult = data?.getAllDimensions {
            XCTAssertGreaterThan(countElementsResult, countElementInTableMustGreater)
            XCTAssertEqual(countElementsResult, countElementInTableInFact)
        }
        
    }
    
    func test_setAndGetStateToleranceValue() {
        
        let newSetTolerance: ChosenTolerance = .it11
        
        data = DataStore(with: toleranceForInit)
        
        XCTAssertEqual(toleranceForInit, data?.getStateToleranceValue)
        
        data?.setTolerance(tolerance: newSetTolerance)
        
        XCTAssertNotEqual(toleranceForInit, data?.getStateToleranceValue)
        XCTAssertEqual(newSetTolerance, data?.getStateToleranceValue)
        
    }
    
    func test_getToleranceValue() {
        
        data = DataStore(with: toleranceForInit)
        
        if let string = data?.getToleranceValue(with: 0) {
            print(string)
            
            XCTAssertNotNil(string)
        }
    }
    
    func test_getValue() {
        
        let digitForCompare = 0.0
        let symbolForCompare = "unknown"
        
        data = DataStore(with: toleranceForInit)
        
        if let (tolerance, symbol) = data?.getValue(with: 0) {
            XCTAssertNotEqual(tolerance, digitForCompare)
            XCTAssertNotEqual(symbol, symbolForCompare)
        }
        
    }
    
    //TODO: - Тест NotificationCenter у свойства stateTolerance
    
    func test_stateToleranceDidChanged() {
        
        data = DataStore(with: toleranceForInit)
        
        createToleranceDidChangeObserver()
        
        data?.setTolerance(tolerance: .it10)
        
    }

}
