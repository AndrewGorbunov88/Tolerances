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

    let checkStringArray = ["До 3 мм", "Св. 3 до 6 мм", "Св. 6 до 10 мм", "Св. 10 до 18 мм", "Св. 18 до 30 мм", "Св. 30 до 50 мм", "Св. 50 до 80 мм", "Св. 80 до 120 мм", "Св. 120 до 180 мм", "Св. 180 до 250 мм", "Св. 250 до 315 мм", "Св. 315 до 400 мм", "Св. 400 до 500 мм", "Св. 500 до 630 мм", "Св. 630 до 800 мм", "Св. 800 до 1000 мм", "Св. 1000 до 1250 мм", "Св. 1250 до 1600 мм", "Св. 1600 до 2000 мм", "Св. 2000 до 2500 мм", "Св. 2500 до 3150 мм", "Св. 3150 до 4000 мм", "Св. 4000 до 5000 мм", "Св. 5000 до 6300 мм", "Св. 6300 до 8000 мм"]
    
    override func setUp() {
        super.setUp()
        data = DataStore()
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
    
    func test_setAndGetStateToleranceValue() {
        
        let newSetTolerance: ChosenTolerance = .it11
        
        XCTAssertEqual(toleranceForInit, data?.getStateToleranceValue)
        
        data?.setTolerance(tolerance: newSetTolerance)
        
        XCTAssertNotEqual(toleranceForInit, data?.getStateToleranceValue)
        XCTAssertEqual(newSetTolerance, data?.getStateToleranceValue)
        
    }
    
    func test_getElement() {
        
        checkStringArray.indices.forEach { index in
            let getResult = data?.getElement(with: index)
            
            if let result = getResult {
                XCTAssertTrue(!result.isEmpty)
            }
            
            XCTAssertNotNil(getResult)
            XCTAssertEqual(getResult, checkStringArray[index])
        }
                
    }
    
    func test_getToleranceValue() {
        
        let checkFulltString = "0.0 unknown"
        let checkValueString = "0.0"
        let checkSymbolString = "unknown"
        
        checkStringArray.indices.forEach { index in
            if let string = data?.getToleranceValue(with: index) {
                
                let separateString = string.components(separatedBy: " ")
                
                XCTAssertNotNil(string)
                XCTAssertEqual(checkValueString, separateString.first)
                XCTAssertEqual(checkSymbolString, separateString.last)
                XCTAssertEqual(checkFulltString, string)
            }
        }
        
        data?.setTolerance(tolerance: toleranceForInit)
        
        checkStringArray.indices.forEach { index in
            if let string = data?.getToleranceValue(with: index) {
                
                let separateString = string.components(separatedBy: " ")
                
                XCTAssertNotNil(string)
                XCTAssertNotEqual(checkValueString, separateString.first)
                XCTAssertNotEqual(checkSymbolString, separateString.last)
                XCTAssertNotEqual(checkFulltString, string)
            }
        }
        
    }
    
    func test_getValue() {
        
        let digitForCompare = 0.0
        let symbolForCompare = "unknown"
        
        data?.setTolerance(tolerance: toleranceForInit)
        
        checkStringArray.indices.forEach { index in
            if let (tolerance, symbol) = data?.getValue(with: index) {
                XCTAssertNotEqual(tolerance, digitForCompare)
                XCTAssertNotEqual(symbol, symbolForCompare)
            }
        }
        
    }
    
    func test_buffers() {
        
        data?.setTolerance(tolerance: toleranceForInit)
        let stateAfterInit = data?.getStateToleranceValue
        
        data?.setBuffers()
        XCTAssertEqual(stateAfterInit, toleranceForInit)
        
        data?.setTolerance(tolerance: .it11)
        let stateAfterSet = data?.getStateToleranceValue
        XCTAssertNotEqual(stateAfterInit, stateAfterSet)
        
        data?.setAllDimensionsFromBuffers()
        let stateAfterRecoverFromBuffer = data?.getStateToleranceValue
        XCTAssertEqual(stateAfterRecoverFromBuffer, toleranceForInit)
        
        data?.clearBuffers()
        data?.setAllDimensionsFromBuffers()
        let stateAfterClearBuffer = data?.getStateToleranceValue
        XCTAssertEqual(stateAfterClearBuffer, toleranceForInit)
        
        
    }
    
    func test_getAllDimensions() {
        
        let countElementInTableMustGreater = 0
        let countElementInTableInFact = checkStringArray.count
        
        if let countElementsResult = data?.getAllDimensions {
            XCTAssertGreaterThan(countElementsResult, countElementInTableMustGreater)
            XCTAssertEqual(countElementsResult, countElementInTableInFact)
        }
        
    }
    
    func test_getStateToleranceValue() {
        
        let initState = data?.getStateToleranceValue
        XCTAssertNotNil(initState)
        XCTAssertEqual(initState, toleranceForInit)
        
        data?.setTolerance(tolerance: .it11)
        let newState = data?.getStateToleranceValue
        XCTAssertNotEqual(newState, initState)
        
    }
    
    func test_searchingDimension() {
        
        let compareValue = "Св. 30 до 50 мм"
        let compareValue2 = "Св. 6 до 10 мм"
        
        let variantsSearchingArray = ["35", "35.1", "35,1", "35.", "35,"]
        
        data?.setTolerance(tolerance: toleranceForInit)
        
        variantsSearchingArray.forEach { dimension in
            data?.tolerance(in: dimension)
            let resultDimension = data?.getElement(with: 0)
            
            XCTAssertEqual(resultDimension, compareValue)
            XCTAssertNotEqual(resultDimension, compareValue2)
        }        
        
    }
    
    
    //TODO: - Тест NotificationCenter у свойства stateTolerance
    
    func test_stateToleranceDidChanged() {
        
        createToleranceDidChangeObserver()
        
        data?.setTolerance(tolerance: .it10)
        
    }

}
