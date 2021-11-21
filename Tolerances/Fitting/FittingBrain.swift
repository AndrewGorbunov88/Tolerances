//
//  FittingBrain.swift
//  Tolerances
//
//  Created by Андрей Горбунов on 06.11.2021.
//

import Foundation

enum HoleOrShaftParameters {
    case dMaxHole
    case dMinHole
    case dMaxShaft
    case dMinShaft
    case sMax
    case sMin
}

enum FittingResult: String {
    case pressFit = "С натягом"
    case clearanceFit = "С зазором"
    case transitionFit = "Переходная"
    case noneFit = "-"
}

struct FittingBrain {
    
    private var valuesDict = [HoleOrShaftParameters: Measurement<UnitLength>]()
    
    mutating func setValues(diameterValue: Double,
                            esHole: Double,
                            eiHole: Double,
                            holeUnit: UnitLength,
                            esShaft: Double,
                            eiShaft: Double,
                            shaftUnit: UnitLength) {
        
        valuesDict.removeValue(forKey: .dMaxHole)
        valuesDict.removeValue(forKey: .dMinHole)
        valuesDict.removeValue(forKey: .dMaxShaft)
        valuesDict.removeValue(forKey: .dMinShaft)
        
        var holeDMax = Measurement(value: esHole, unit: holeUnit).converted(to: .millimeters)
        holeDMax.value += diameterValue
        
        var holeDMin = Measurement(value: eiHole, unit: holeUnit).converted(to: .millimeters)
        holeDMin.value += diameterValue
        
        var shaftDMax = Measurement(value: esShaft, unit: shaftUnit).converted(to: .millimeters)
        shaftDMax.value += diameterValue
        
        var shaftDMin = Measurement(value: eiShaft, unit: shaftUnit).converted(to: .millimeters)
        shaftDMin.value += diameterValue
        
        var maxValue = Measurement(value: 0, unit: UnitLength.millimeters)
        var minValue = Measurement(value: 0, unit: UnitLength.millimeters)
        
        if shaftDMin.value > holeDMax.value {
            maxValue = shaftDMax - holeDMin
            minValue = shaftDMin - holeDMax
        } else if holeDMin.value > shaftDMax.value {
            maxValue = holeDMax - shaftDMin
            minValue = holeDMin - shaftDMax
        } else {
            maxValue = holeDMax - shaftDMin
            minValue = shaftDMax - holeDMin
        }
        
        valuesDict[.dMaxHole] = holeDMax
        valuesDict[.dMinHole] = holeDMin
        valuesDict[.dMaxShaft] = shaftDMax
        valuesDict[.dMinShaft] = shaftDMin
        valuesDict[.sMax] = maxValue
        valuesDict[.sMin] = minValue
        
    }
    
    func getResult(for parameter: HoleOrShaftParameters) -> String {
        let resultString = String((valuesDict[parameter]!.value * 1000).rounded() / 1000) + " " + (valuesDict[parameter]?.unit.symbol)!
        
        return resultString
    }
    
    func getFitResult() -> String {
        var fitResult: String?
        
        if valuesDict[.dMinShaft]!.value > valuesDict[.dMaxHole]!.value {
            fitResult = FittingResult.pressFit.rawValue
        } else if valuesDict[.dMinHole]!.value > valuesDict[.dMaxShaft]!.value {
            fitResult = FittingResult.clearanceFit.rawValue
        } else {
            fitResult = FittingResult.transitionFit.rawValue
        }
        
        return fitResult!
        
    }
        
}
