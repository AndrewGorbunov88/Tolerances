//
//  DataHolesAndShaftsTests.swift
//  TolerancesTests
//
//  Created by Андрей Горбунов on 29.09.2021.
//

@testable import Tolerances
import XCTest

class DataHolesAndShaftsTests: XCTestCase {
    
    var dataHoles: DataHolesAndShafts?
    var dataShafts: DataHolesAndShafts?
    
    override func setUp() {
        super.setUp()
        dataHoles = DataHolesAndShafts(choseFieldState: .hole)
        dataShafts = DataHolesAndShafts(choseFieldState: .shaft)
    }
    
    override func tearDown() {
        dataHoles = nil
        dataShafts = nil
        super.tearDown()
    }
    
    func test_getTolerancesCountForCell() {
        let countCellsHoles = dataHoles?.getTolerancesCountForCell
        let countCellsShafts = dataShafts?.getTolerancesCountForCell
        XCTAssertNotNil(countCellsHoles)
        XCTAssertNotNil(countCellsShafts)
    }
    
    func test_getFieldsCountForPickerView() {
        let countFieldsHoles = HoleFields.allCases.count
        let countHoles = dataHoles?.getFieldsCountForPickerView
        
        XCTAssertEqual(countFieldsHoles, countHoles)
        
        let countShaftsHoles = ShaftFields.allCases.count
        let countShafts = dataShafts?.getFieldsCountForPickerView
        
        XCTAssertEqual(countShaftsHoles, countShafts)
    }
    
    func test_getToleranceCountForPickerView() {
        let countForPickerViewDataHoles = dataHoles?.getToleranceCountForPickerView
        
        XCTAssertNotNil(countForPickerViewDataHoles)
        
        let countForPickerViewDataShafts = dataShafts?.getToleranceCountForPickerView
        
        XCTAssertNotNil(countForPickerViewDataShafts)
    }
    
    func test_getChoseState() {
        let holesState = (dataHoles?.getChoseState as! HoleFields).rawValue
        let shaftState = (dataShafts?.getChoseState as! ShaftFields).rawValue

        HoleFields.allCases.forEach { holeField in
            if holeField.rawValue == holesState {
                XCTAssertEqual(holeField.rawValue, holesState)
            } else {
                XCTAssertNotEqual(holeField.rawValue, holesState)
            }
        }
        
        ShaftFields.allCases.forEach { shaftField in
            if shaftField.rawValue == shaftState {
                XCTAssertEqual(shaftField.rawValue, shaftState)
            } else {
                XCTAssertNotEqual(shaftField.rawValue, shaftState)
            }
        }
    }
    
    func test_getDimensionState() {
        let selectedDimensiontState = 0
        
        dataHoles?.setDimensionsHolesOrShaftsForTable(at: selectedDimensiontState)
        let holeDimensionState = dataHoles?.getDimensionState
        
        XCTAssertEqual(selectedDimensiontState, holeDimensionState)
        
        dataShafts?.setDimensionsHolesOrShaftsForTable(at: selectedDimensiontState)
        let shaftDimensionState = dataShafts?.getDimensionState
        
        XCTAssertEqual(selectedDimensiontState, shaftDimensionState)
    }
    
    func test_getDefaultNameForHeader() {
        let checkHoleString = "H01"
        let checkShaftString = "h01"
        
        let checkHoleStringAfterSet = "H0"
        let checkShaftStringAfterSet = "h0"
        
        XCTAssertEqual(checkHoleString, dataHoles?.getDefaultNameForHeader())
        XCTAssertEqual(checkShaftString, dataShafts?.getDefaultNameForHeader())
        
        dataHoles?.setDimensionsHolesOrShaftsForTable(at: 1)
        dataShafts?.setDimensionsHolesOrShaftsForTable(at: 1)
        
        XCTAssertEqual(checkHoleStringAfterSet, dataHoles?.getDefaultNameForHeader())
        XCTAssertEqual(checkShaftStringAfterSet, dataShafts?.getDefaultNameForHeader())
    }
    
    func test_getFieldNameForRowsInPickerView() {
        
        HoleFields.allCases.indices.forEach { holeField in
            let field = dataHoles?.getFieldNameForRowsInPickerView(with: holeField)
            XCTAssertEqual(HoleFields.allCases[holeField].rawValue, field)
        }
        
        ShaftFields.allCases.indices.forEach { shaftField in
            let field = dataShafts?.getFieldNameForRowsInPickerView(with: shaftField)
            XCTAssertEqual(ShaftFields.allCases[shaftField].rawValue, field)
        }
        
    }
    
    func test_getTolerancesNameForRowsInPickerView() {
        
        
        
    }
    
    func test_setHoleOrShaftFieldForTable() {
        
        dataHoles?.setHoleOrShaftFieldForTable(at: 0, and: 0)
        var countHoleDimension = dataHoles?.getToleranceCountForPickerView
        
        HoleFields.allCases.indices.forEach { holeField in
            
            dataHoles?.setHoleOrShaftFieldForTable(at: holeField, and: countHoleDimension!)
            
            if countHoleDimension! != dataHoles!.getToleranceCountForPickerView {
                countHoleDimension = dataHoles?.getToleranceCountForPickerView
            }
            
            
            for index in 0..<countHoleDimension! {
                
                dataHoles?.setHoleOrShaftFieldForTable(at: holeField, and: index)
                
                if let field = dataHoles?.getFieldNameForRowsInPickerView(with: holeField) {
                    XCTAssertEqual(HoleFields.allCases[holeField].rawValue, field)
                    
                    if let toleranceName = dataHoles?.getTolerancesNameForRowsInPickerView(with: index) {
                        let name = "\(field)\(toleranceName)"
                        XCTAssertEqual(dataHoles?.getDefaultNameForHeader(), name)
                    }
                }
                
            }
            
        }
        
        dataShafts?.setHoleOrShaftFieldForTable(at: 0, and: 0)
        var countShaftDimension = dataShafts?.getToleranceCountForPickerView
        
        ShaftFields.allCases.indices.forEach { shaftField in
            
            dataShafts?.setHoleOrShaftFieldForTable(at: shaftField, and: countShaftDimension!)
            
            if countShaftDimension! != dataShafts!.getToleranceCountForPickerView {
                countShaftDimension = dataShafts?.getToleranceCountForPickerView
            }
            
            
            for index in 0..<countShaftDimension! {
                
                dataShafts?.setHoleOrShaftFieldForTable(at: shaftField, and: index)
                
                if let field = dataShafts?.getFieldNameForRowsInPickerView(with: shaftField) {
                    XCTAssertEqual(ShaftFields.allCases[shaftField].rawValue, field)
                    
                    if let toleranceName = dataShafts?.getTolerancesNameForRowsInPickerView(with: index) {
                        let name = "\(field)\(toleranceName)"
                        XCTAssertEqual(dataShafts?.getDefaultNameForHeader(), name)
                    }
                }
                
            }
            
        }
    }
    
}
