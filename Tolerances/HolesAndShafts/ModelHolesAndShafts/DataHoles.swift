//
//  DataHoles.swift
//  Tolerances
//
//  Created by Андрей Горбунов on 23.05.2021.
//

import Foundation

protocol Fields {
    
}

enum HoleFields: String, CaseIterable, Fields {
    case a = "A"
    case b = "B"
    case c = "C"
    case d = "D"
    case e = "E"
    case f = "F"
    case g = "G"
    case h = "H"
    case js = "JS"
    case k = "K"
    case m = "M"
    case n = "N"
    case p = "P"
    case r = "R"
    case s = "S"
    case t = "T"
    case u = "U"
}

enum ShaftFields: String, CaseIterable, Fields {
    case a = "a"
    case b = "b"
    case c = "c"
    case d = "d"
    case e = "e"
    case f = "f"
    case g = "g"
    case h = "h"
    case js = "js"
    case k = "k"
    case m = "m"
    case n = "n"
    case p = "p"
    case r = "r"
    case s = "s"
    case t = "t"
    case u = "u"
}

class DataHolesAndShafts {
    
    private var choseFieldState: Fields?
    private var choseDimensionState: Int? = 0
    private var nameField = ""
    private var nameDimension = ""
    private var bufferNameField = ""
    private var bufferNameDimension = ""
    private var bufferChoseFieldState: Fields?
    private var bufferChoseDimensionState: Int?
    
    private let nameSize = ["До 3",
                            "Св. 3 до 6",
                            "Св. 6 до 10",
                            "Св. 10 до 18",
                            "Св. 18 до 30",
                            "Св. 30 до 50",
                            "Св. 50 до 80",
                            "Св. 80 до 120",
                            "Св. 120 до 180",
                            "Св. 180 до 250",
                            "Св. 250 до 315",
                            "Св. 315 до 400",
                            "Св. 400 до 500"]
    
    //MARK: - Имена полей для отверстий
    private let nameABCHolesSizes = ["До 3",
                            "Св. 3 до 6",
                            "Св. 6 до 10",
                            "Св. 10 до 18",
                            "Св. 18 до 30",
                            "Св. 30 до 40",
                            "Св. 40 до 50",
                            "Св. 50 до 65",
                            "Св. 65 до 80",
                            "Св. 80 до 100",
                            "Св. 100 до 120",
                            "Св. 120 до 140",
                            "Св. 140 до 160",
                            "Св. 160 до 180",
                            "Св. 180 до 200",
                            "Св. 200 до 225",
                            "Св. 225 до 250",
                            "Св. 250 до 280",
                            "Св. 280 до 315",
                            "Св. 315 до 355",
                            "Св. 355 до 400",
                            "Св. 400 до 450",
                            "Св. 450 до 500"]
    
    private let nameRSHolesSizes = ["До 3",
                            "Св. 3 до 6",
                            "Св. 6 до 10",
                            "Св. 10 до 18",
                            "Св. 18 до 30",
                            "Св. 30 до 50",
                            "Св. 50 до 65",
                            "Св. 65 до 80",
                            "Св. 80 до 100",
                            "Св. 100 до 120",
                            "Св. 120 до 140",
                            "Св. 140 до 160",
                            "Св. 160 до 180",
                            "Св. 180 до 200",
                            "Св. 200 до 225",
                            "Св. 225 до 250",
                            "Св. 250 до 280",
                            "Св. 280 до 315",
                            "Св. 315 до 355",
                            "Св. 355 до 400",
                            "Св. 400 до 450",
                            "Св. 450 до 500"]
    
    private let nameTHolesSizes = ["До 3",
                            "Св. 3 до 6",
                            "Св. 6 до 10",
                            "Св. 10 до 18",
                            "Св. 18 до 24",
                            "Св. 24 до 30",
                            "Св. 30 до 40",
                            "Св. 40 до 50",
                            "Св. 50 до 65",
                            "Св. 65 до 80",
                            "Св. 80 до 100",
                            "Св. 100 до 120",
                            "Св. 120 до 140",
                            "Св. 140 до 160",
                            "Св. 160 до 180",
                            "Св. 180 до 200",
                            "Св. 200 до 225",
                            "Св. 225 до 250",
                            "Св. 250 до 280",
                            "Св. 280 до 315",
                            "Св. 315 до 355",
                            "Св. 355 до 400",
                            "Св. 400 до 450",
                            "Св. 450 до 500"]
    
    private let nameUHolesSizes = ["До 3",
                            "Св. 3 до 6",
                            "Св. 6 до 10",
                            "Св. 10 до 18",
                            "Св. 18 до 24",
                            "Св. 24 до 30",
                            "Св. 30 до 40",
                            "Св. 40 до 50",
                            "Св. 50 до 65",
                            "Св. 65 до 80",
                            "Св. 80 до 100",
                            "Св. 100 до 120",
                            "Св. 120 до 140",
                            "Св. 140 до 160",
                            "Св. 160 до 180",
                            "Св. 180 до 200",
                            "Св. 200 до 225",
                            "Св. 225 до 250",
                            "Св. 250 до 280",
                            "Св. 280 до 315",
                            "Св. 315 до 355",
                            "Св. 355 до 400",
                            "Св. 400 до 450",
                            "Св. 450 до 500"]
    
    private let ranges = [0.0...3.0,
                          3.01...6.0,
                          6.01...10.0,
                          10.01...18.0,
                          18.01...30,
                          30.01...50.0,
                          50.01...80.0,
                          80.01...120.0,
                          120.01...180.0,
                          180.01...250.0,
                          250.01...315.0,
                          315.01...400,
                          400.01...500]
    
    //ES - верхнее отклонение, EI - нижнее отклонение
    private var dimensionsHolesOrShafts: [(range: ClosedRange<Double>?,
                                   es: Double?,
                                   ei: Double?,
                                   unit: UnitLength?)] = [] {
        didSet {
            
            let toleranceHoleInfo = ["didHoleDimensionsChange": dimensionsHolesOrShafts]
            NotificationCenter.default.post(name: .didHoleDimensionsChange, object: nil, userInfo: toleranceHoleInfo as [AnyHashable : Any])
        }
        
    }
    
    private var bufferDimensionsHoles: [(range: ClosedRange<Double>?,
                                         es: Double?,
                                         ei: Double?,
                                         unit: UnitLength?)] = []
    
    private var fieldOfToleranceArray: [(field: [(range: ClosedRange<Double>,
                                                  es: Double,
                                                  ei: Double,
                                                  unit: UnitLength)],
                                         name: String)] = [] {
        didSet {
            let toleranceHoleInfo = ["didHoleDimensionsChange": fieldOfToleranceArray]
            NotificationCenter.default.post(name: .didHoleDimensionsChange, object: nil, userInfo: toleranceHoleInfo as [AnyHashable : Any])
        }
    }
    
    private var bufferFieldOfToleranceArray: [(field: [(range: ClosedRange<Double>,
                                                        es: Double,
                                                        ei: Double,
                                                        unit: UnitLength)],
                                               name: String)] = []
    
    private var holeSizes: HolesSizes?
    private var shaftSizes: ShaftSizes?
    
    var getTolerancesCountForCell: Int {
        get {
            dimensionsHolesOrShafts.count
        }
    }
    
    var getFieldsCountForPickerView: Int {
        get {
            var count = 0
            
            if choseFieldState is HoleFields {
                count = HoleFields.allCases.count
            }
            
            if choseFieldState is ShaftFields {
                count = ShaftFields.allCases.count
            }
            
            return count
        }
    }
    
    var getToleranceCountForPickerView: Int {
        get {
            fieldOfToleranceArray.count
        }
    }
    
    var getChooseState: Fields {
        get {
            choseFieldState!
        }
    }
    
    var getDimensionState: Int {
        get {
            choseDimensionState!
        }
    }
        
    init(choseFieldState: Fields) {
        self.choseFieldState = choseFieldState
        
        if self.choseFieldState is HoleFields {
            let holes = HolesSizes()
            holeSizes = holes
        } else {
            let shafts = ShaftSizes()
            shaftSizes = shafts
        }
        
        installDimensionHoles()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Methods
    
    private func installDimensionHoles() {
        
        if self.choseFieldState is HoleFields {
            if let choose = (choseFieldState as? HoleFields) {
                fieldOfToleranceArray = holeSizes!.getToleranceFields(choose)
                nameField = choose.rawValue
            }
        }
        
        if self.choseFieldState is ShaftFields {
            if let choose = (choseFieldState as? ShaftFields) {
                fieldOfToleranceArray = shaftSizes!.getToleranceFields(choose)
                nameField = choose.rawValue
            }
        }
        
        dimensionsHolesOrShafts = fieldOfToleranceArray[choseDimensionState!].field
        
        nameDimension = fieldOfToleranceArray[choseDimensionState!].name
        
        
    }
    
    func getDefaultNameForHeader() -> String {
               
        var nameForHeaderInTableView = String()
        nameForHeaderInTableView = "\(nameField)\(nameDimension)"
        
        return nameForHeaderInTableView
    }
    
    func getFieldNameForRowsInPickerView(with element: Int) -> String {
        
        var name = String()
        
        var arrayFields = [Fields]()
        
        if choseFieldState is HoleFields {
            arrayFields = HoleFields.allCases
            
            name = (arrayFields[element] as! HoleFields).rawValue
        }
        
        if choseFieldState is ShaftFields {
            arrayFields = ShaftFields.allCases
            
            name = (arrayFields[element] as! ShaftFields).rawValue
        }
        
        return name
    }
    
    func getTolerancesNameForRowsInPickerView(with element: Int) -> String {
        
        return fieldOfToleranceArray[element].name
    }
    
    func setHoleOrShaftFieldForTable(at index: Int, and row: Int) {
        
        if self.choseFieldState is HoleFields {
            choseFieldState = HoleFields.allCases[index]
            fieldOfToleranceArray = holeSizes!.getToleranceFields(choseFieldState! as! HoleFields)
            nameField = (choseFieldState! as! HoleFields).rawValue
        }
        
        if self.choseFieldState is ShaftFields {
            choseFieldState = ShaftFields.allCases[index]
            fieldOfToleranceArray = shaftSizes!.getToleranceFields(choseFieldState! as! ShaftFields)
            nameField = (choseFieldState! as! ShaftFields).rawValue
        }
        
        if (fieldOfToleranceArray.count - 1) > row {
            dimensionsHolesOrShafts = fieldOfToleranceArray[row].field
            nameDimension = fieldOfToleranceArray[row].name
        } else {
            dimensionsHolesOrShafts = fieldOfToleranceArray.last!.field
            nameDimension = fieldOfToleranceArray.last!.name
        }
        
    }
    
    func setDimensionsHolesOrShaftsForTable(at index: Int) {
        choseDimensionState = index
        dimensionsHolesOrShafts = fieldOfToleranceArray[index].field
        nameDimension = fieldOfToleranceArray[index].name
    }
    
    func setBuffers() {
        self.bufferFieldOfToleranceArray = self.fieldOfToleranceArray
        self.bufferDimensionsHoles = self.dimensionsHolesOrShafts
        self.bufferNameField = self.nameField
        self.bufferNameDimension = self.nameDimension
        self.bufferChoseFieldState = self.choseFieldState
        self.bufferChoseDimensionState = self.choseDimensionState
        
    }
    
    func setAllDimensionsFromBuffers() {
        self.fieldOfToleranceArray = self.bufferFieldOfToleranceArray
        self.dimensionsHolesOrShafts = self.bufferDimensionsHoles
        self.nameField = self.bufferNameField
        self.nameDimension = self.bufferNameDimension
        self.choseFieldState = self.bufferChoseFieldState
        self.choseDimensionState = self.bufferChoseDimensionState
    }
    
    func clearBuffers() {
        self.bufferDimensionsHoles = []
        self.bufferFieldOfToleranceArray = []
        self.bufferNameField = ""
        self.bufferNameDimension = ""
        self.bufferChoseFieldState = nil
        self.bufferChoseDimensionState = nil
    }
    
    func getDataForCell(at index: Int) -> (range: ClosedRange<Double>?, es: Double?, ei: Double?, unit: UnitLength?) {
        let range = dimensionsHolesOrShafts[index].range
        let esTolerance = dimensionsHolesOrShafts[index].es
        let eiTolerance = dimensionsHolesOrShafts[index].ei
        let unit = dimensionsHolesOrShafts[index].unit
        
        return (range: range, es: esTolerance, ei: eiTolerance, unit: unit)
    }
    
    func getNameTolerances(at index: Int) -> String {
        if choseFieldState is HoleFields {
            switch choseFieldState as! HoleFields {
            case .a:
                return nameABCHolesSizes[index]
            case .b:
                return nameABCHolesSizes[index]
            case .c:
                return nameABCHolesSizes[index]
            case .r:
                return nameRSHolesSizes[index]
            case .s:
                return nameRSHolesSizes[index]
            case .t:
                return nameTHolesSizes[index]
            case .u:
                return nameUHolesSizes[index]
            default:
                return nameSize[index]
            }
        }
        
        //TODO: Реализовать выбор валов
        if choseFieldState is ShaftFields {
            switch choseFieldState as! ShaftFields {
            case .a:
                return nameABCHolesSizes[index]
            default:
                return nameSize[index]
            }
        } else {
            return ""
        }
        
    }
    
}
