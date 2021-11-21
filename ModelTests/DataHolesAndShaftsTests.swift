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
    
    func test_setDimensionsHolesAndShaftsForTable() {
        
        let compareHoleString = "H01"
        let compareHoleStringAfterSet = "H7"
        let compareShaftString = "h01"
        let compareShaftStringAfterSet = "h7"
        let startingNumberFieldName = 7
        let startingNumberDimension = 0
        let endingNumberDimension = 8
        
        dataHoles?.setHoleOrShaftFieldForTable(at: startingNumberFieldName, and: startingNumberDimension)
        
        dataHoles?.setDimensionsHolesOrShaftsForTable(at: startingNumberDimension)
        
        if let field = dataHoles?.getFieldNameForRowsInPickerView(with: startingNumberFieldName) {
            XCTAssertEqual(HoleFields.allCases[startingNumberFieldName].rawValue, field)
            
            if let toleranceName = dataHoles?.getTolerancesNameForRowsInPickerView(with: startingNumberDimension) {
                let name = "\(field)\(toleranceName)"
                XCTAssertEqual(compareHoleString, name)
            }
            
            dataHoles?.setDimensionsHolesOrShaftsForTable(at: endingNumberDimension)
            
            if let toleranceNameAfterSet = dataHoles?.getTolerancesNameForRowsInPickerView(with: endingNumberDimension) {
                let name = "\(field)\(toleranceNameAfterSet)"
                XCTAssertEqual(compareHoleStringAfterSet, name)
            }
            
        }
        
        dataShafts?.setHoleOrShaftFieldForTable(at: startingNumberFieldName, and: startingNumberDimension)
        
        dataShafts?.setDimensionsHolesOrShaftsForTable(at: startingNumberDimension)
        
        if let field = dataShafts?.getFieldNameForRowsInPickerView(with: startingNumberFieldName) {
            XCTAssertEqual(ShaftFields.allCases[startingNumberFieldName].rawValue, field)
            
            if let toleranceName = dataShafts?.getTolerancesNameForRowsInPickerView(with: startingNumberDimension) {
                let name = "\(field)\(toleranceName)"
                XCTAssertEqual(compareShaftString, name)
            }
            
            dataShafts?.setDimensionsHolesOrShaftsForTable(at: endingNumberDimension)
            
            if let toleranceNameAfterSet = dataShafts?.getTolerancesNameForRowsInPickerView(with: endingNumberDimension) {
                let name = "\(field)\(toleranceNameAfterSet)"
                XCTAssertEqual(compareShaftStringAfterSet, name)
            }
            
        }
        
    }
    
    func test_getDataForCell() {
        
        let searchingSize = "56"
        let startIndexPath = 0
        let indexPathAfterSet = 5
        
        dataHoles?.setHoleOrShaftFieldForTable(at: 0, and: 0)
        var dataTuple = dataHoles?.getDataForCell(at: startIndexPath)
        var name = dataHoles?.getNameTolerances(at: startIndexPath)
        
        XCTAssertGreaterThan(dataHoles!.getTolerancesCountForCell , 0)
        XCTAssertNotNil(dataTuple?.range)
        XCTAssertNotNil(dataTuple?.es)
        XCTAssertNotNil(dataTuple?.ei)
        XCTAssertNotNil(dataTuple?.unit)
        
        dataHoles?.tolerance(in: searchingSize)
        
        XCTAssertLessThanOrEqual(dataHoles!.getTolerancesCountForCell, 2)
        XCTAssertNotNil(dataTuple?.range)
        XCTAssertNotNil(dataTuple?.es)
        XCTAssertNotNil(dataTuple?.ei)
        XCTAssertNotNil(dataTuple?.unit)
        
        dataHoles?.tolerance(in: "")
        
        dataTuple = dataHoles?.getDataForCell(at: indexPathAfterSet)
        XCTAssertNotNil(dataTuple?.range)
        XCTAssertNotNil(dataTuple?.es)
        XCTAssertNotNil(dataTuple?.ei)
        XCTAssertNotNil(dataTuple?.unit)
        
    }
    
}
