//
//  DataStore.swift
//  Tolerances
//
//  Created by Андрей Горбунов on 08.04.2021.
//

import Foundation

class DataStore {
    
    private var searchState = false
    
    private var bufferNameField = ""
    private var bufferChoseFieldState: ChosenTolerance?
    
    private var stateTolerance: ChosenTolerance? {
        didSet {
            installRangeAndToleranceInDimensions()
            
            let toleranceInfo = ["didToleranceChange": stateTolerance]
            NotificationCenter.default.post(name: .didToleranceChange, object: nil, userInfo: toleranceInfo as [AnyHashable : Any])
        }
    }
    
    private var dimensions: [(name: String,
                              range: ClosedRange<Double>?,
                              tolerance: Double?,
                              unit: UnitLength?)] = [(name: "До 3 мм", range: nil, tolerance: nil, unit: nil),
                                                     (name: "Св. 3 до 6 мм", range: nil, tolerance: nil, unit: nil),
                                                     (name: "Св. 6 до 10 мм", range: nil, tolerance: nil, unit: nil),
                                                     (name: "Св. 10 до 18 мм", range: nil, tolerance: nil, unit: nil),
                                                     (name: "Св. 18 до 30 мм", range: nil, tolerance: nil, unit: nil),
                                                     (name: "Св. 30 до 50 мм", range: nil, tolerance: nil, unit: nil),
                                                     (name: "Св. 50 до 80 мм", range: nil, tolerance: nil, unit: nil),
                                                     (name: "Св. 80 до 120 мм", range: nil, tolerance: nil, unit: nil),
                                                     (name: "Св. 120 до 180 мм", range: nil, tolerance: nil, unit: nil),
                                                     (name: "Св. 180 до 250 мм", range: nil, tolerance: nil, unit: nil),
                                                     (name: "Св. 250 до 315 мм", range: nil, tolerance: nil, unit: nil),
                                                     (name: "Св. 315 до 400 мм", range: nil, tolerance: nil, unit: nil),
                                                     (name: "Св. 400 до 500 мм", range: nil, tolerance: nil, unit: nil),
                                                     (name: "Св. 500 до 630 мм", range: nil, tolerance: nil, unit: nil),
                                                     (name: "Св. 630 до 800 мм", range: nil, tolerance: nil, unit: nil),
                                                     (name: "Св. 800 до 1000 мм", range: nil, tolerance: nil, unit: nil),
                                                     (name: "Св. 1000 до 1250 мм", range: nil, tolerance: nil, unit: nil),
                                                     (name: "Св. 1250 до 1600 мм", range: nil, tolerance: nil, unit: nil),
                                                     (name: "Св. 1600 до 2000 мм", range: nil, tolerance: nil, unit: nil),
                                                     (name: "Св. 2000 до 2500 мм", range: nil, tolerance: nil, unit: nil),
                                                     (name: "Св. 2500 до 3150 мм", range: nil, tolerance: nil, unit: nil),
                                                     (name: "Св. 3150 до 4000 мм", range: nil, tolerance: nil, unit: nil),
                                                     (name: "Св. 4000 до 5000 мм", range: nil, tolerance: nil, unit: nil),
                                                     (name: "Св. 5000 до 6300 мм", range: nil, tolerance: nil, unit: nil),
                                                     (name: "Св. 6300 до 8000 мм", range: nil, tolerance: nil, unit: nil)] {
        didSet {
            let toleranceInfo = ["didToleranceChange": stateTolerance]
            NotificationCenter.default.post(name: .didToleranceChange, object: nil, userInfo: toleranceInfo as [AnyHashable : Any])
        }
    }
    
    private var sortedDimensions: [(name: String,
                                   range: ClosedRange<Double>?,
                                   tolerance: Double?,
                                   unit: UnitLength?)] = []
    
    private var dictionaryTolerance = [ChosenTolerance: [(range: ClosedRange<Double>, tolerance: Double, unit: UnitLength)]]()
    
    private let it01 = [(range: 0.0...3.0, tolerance: Double(0.3), unit: UnitLength.micrometers),
                        (range: 3.0...6.0, tolerance: Double(0.4), unit: UnitLength.micrometers),
                        (range: 6.0...10.0, tolerance: Double(0.4), unit: UnitLength.micrometers),
                        (range: 10.0...18.0, tolerance: Double(0.5), unit: UnitLength.micrometers),
                        (range: 18.0...30, tolerance: Double(0.6), unit: UnitLength.micrometers),
                        (range: 30.0...50.0, tolerance: Double(0.6), unit: UnitLength.micrometers),
                        (range: 50.0...80.0, tolerance: Double(0.8), unit: UnitLength.micrometers),
                        (range: 80.0...120.0, tolerance: Double(1), unit: UnitLength.micrometers),
                        (range: 120.0...180.0, tolerance: Double(1.2), unit: UnitLength.micrometers),
                        (range: 180.0...250.0, tolerance: Double(2), unit: UnitLength.micrometers),
                        (range: 250.0...315.0, tolerance: Double(2.5), unit: UnitLength.micrometers),
                        (range: 315.0...400, tolerance: Double(3), unit: UnitLength.micrometers),
                        (range: 400.0...500, tolerance: Double(4), unit: UnitLength.micrometers),
                        (range: 500.0...630, tolerance: Double(4.5), unit: UnitLength.micrometers),
                        (range: 630.0...800.0, tolerance: Double(5), unit: UnitLength.micrometers),
                        (range: 800.0...1000.0, tolerance: Double(5.5), unit: UnitLength.micrometers),
                        (range: 1000.0...1250, tolerance: Double(6.5), unit: UnitLength.micrometers),
                        (range: 1250.0...1600, tolerance: Double(8), unit: UnitLength.micrometers),
                        (range: 1600.0...2000.0, tolerance: Double(9), unit: UnitLength.micrometers),
                        (range: 2000.0...2500, tolerance: Double(11), unit: UnitLength.micrometers),
                        (range: 2500.0...3150.0, tolerance: Double(13), unit: UnitLength.micrometers),
                        (range: 3150.0...4000, tolerance: Double(16), unit: UnitLength.micrometers),
                        (range: 4000.0...5000.0, tolerance: Double(20), unit: UnitLength.micrometers),
                        (range: 5000.0...6300.0, tolerance: Double(25), unit: UnitLength.micrometers),
                        (range: 6300.0...8000.0, tolerance: Double(31), unit: UnitLength.micrometers)]
    
    private let it0 = [(range: 0.0...3.0, tolerance: Double(0.5), unit: UnitLength.micrometers),
                       (range: 3.0...6.0, tolerance: Double(0.6), unit: UnitLength.micrometers),
                       (range: 6.0...10.0, tolerance: Double(0.6), unit: UnitLength.micrometers),
                       (range: 10.0...18.0, tolerance: Double(0.8), unit: UnitLength.micrometers),
                       (range: 18.0...30.0, tolerance: Double(1), unit: UnitLength.micrometers),
                       (range: 30.0...50.0, tolerance: Double(1), unit: UnitLength.micrometers),
                       (range: 50.0...80.0, tolerance: Double(1.2), unit: UnitLength.micrometers),
                       (range: 80.0...120.0, tolerance: Double(1.5), unit: UnitLength.micrometers),
                       (range: 120.0...180.0, tolerance: Double(2), unit: UnitLength.micrometers),
                       (range: 180.0...250.0, tolerance: Double(3), unit: UnitLength.micrometers),
                       (range: 250.0...315.0, tolerance: Double(4), unit: UnitLength.micrometers),
                       (range: 315.0...400, tolerance: Double(5), unit: UnitLength.micrometers),
                       (range: 400.0...500, tolerance: Double(6), unit: UnitLength.micrometers),
                       (range: 500.0...630, tolerance: Double(6), unit: UnitLength.micrometers),
                       (range: 630.0...800.0, tolerance: Double(7), unit: UnitLength.micrometers),
                       (range: 800.0...1000.0, tolerance: Double(8), unit: UnitLength.micrometers),
                       (range: 1000.0...1250, tolerance: Double(9), unit: UnitLength.micrometers),
                       (range: 1250.0...1600, tolerance: Double(11), unit: UnitLength.micrometers),
                       (range: 1600.0...2000.0, tolerance: Double(13), unit: UnitLength.micrometers),
                       (range: 2000.0...2500, tolerance: Double(15), unit: UnitLength.micrometers),
                       (range: 2500.0...3150.0, tolerance: Double(18), unit: UnitLength.micrometers),
                       (range: 3150.0...4000, tolerance: Double(23), unit: UnitLength.micrometers),
                       (range: 4000.0...5000.0, tolerance: Double(28), unit: UnitLength.micrometers),
                       (range: 5000.0...6300.0, tolerance: Double(35), unit: UnitLength.micrometers),
                       (range: 6300.0...8000.0, tolerance: Double(43), unit: UnitLength.micrometers)]
    
    private let it1 = [(range: 0.0...3.0, tolerance: Double(0.8), unit: UnitLength.micrometers),
                       (range: 3.0...6.0, tolerance: Double(1), unit: UnitLength.micrometers),
                       (range: 6.0...10.0, tolerance: Double(1), unit: UnitLength.micrometers),
                       (range: 10.0...18.0, tolerance: Double(1.2), unit: UnitLength.micrometers),
                       (range: 18.0...30, tolerance: Double(1.5), unit: UnitLength.micrometers),
                       (range: 30.0...50.0, tolerance: Double(1.5), unit: UnitLength.micrometers),
                       (range: 50.0...80.0, tolerance: Double(2), unit: UnitLength.micrometers),
                       (range: 80.0...120.0, tolerance: Double(2.5), unit: UnitLength.micrometers),
                       (range: 120.0...180.0, tolerance: Double(3.5), unit: UnitLength.micrometers),
                       (range: 180.0...250.0, tolerance: Double(4.5), unit: UnitLength.micrometers),
                       (range: 250.0...315.0, tolerance: Double(6), unit: UnitLength.micrometers),
                       (range: 315.0...400, tolerance: Double(7), unit: UnitLength.micrometers),
                       (range: 400.0...500, tolerance: Double(8), unit: UnitLength.micrometers),
                       (range: 500.0...630, tolerance: Double(9), unit: UnitLength.micrometers),
                       (range: 630.0...800.0, tolerance: Double(10), unit: UnitLength.micrometers),
                       (range: 800.0...1000.0, tolerance: Double(11), unit: UnitLength.micrometers),
                       (range: 1000.0...1250, tolerance: Double(13), unit: UnitLength.micrometers),
                       (range: 1250.0...1600, tolerance: Double(15), unit: UnitLength.micrometers),
                       (range: 1600.0...2000.0, tolerance: Double(18), unit: UnitLength.micrometers),
                       (range: 2000.0...2500, tolerance: Double(22), unit: UnitLength.micrometers),
                       (range: 2500.0...3150.0, tolerance: Double(26), unit: UnitLength.micrometers),
                       (range: 3150.0...4000, tolerance: Double(33), unit: UnitLength.micrometers),
                       (range: 4000.0...5000.0, tolerance: Double(40), unit: UnitLength.micrometers),
                       (range: 5000.0...6300.0, tolerance: Double(49), unit: UnitLength.micrometers),
                       (range: 6300.0...8000.0, tolerance: Double(62), unit: UnitLength.micrometers)]
    
    private let it2 = [(range: 0.0...3.0, tolerance: Double(1.2), unit: UnitLength.micrometers),
                       (range: 3.0...6.0, tolerance: Double(1.5), unit: UnitLength.micrometers),
                       (range: 6.0...10.0, tolerance: Double(1.5), unit: UnitLength.micrometers),
                       (range: 10.0...18.0, tolerance: Double(2), unit: UnitLength.micrometers),
                       (range: 18.0...30, tolerance: Double(2.5), unit: UnitLength.micrometers),
                       (range: 30.0...50.0, tolerance: Double(2.5), unit: UnitLength.micrometers),
                       (range: 50.0...80.0, tolerance: Double(3), unit: UnitLength.micrometers),
                       (range: 80.0...120.0, tolerance: Double(4), unit: UnitLength.micrometers),
                       (range: 120.0...180.0, tolerance: Double(5), unit: UnitLength.micrometers),
                       (range: 180.0...250.0, tolerance: Double(7), unit: UnitLength.micrometers),
                       (range: 250.0...315.0, tolerance: Double(8), unit: UnitLength.micrometers),
                       (range: 315.0...400, tolerance: Double(9), unit: UnitLength.micrometers),
                       (range: 400.0...500, tolerance: Double(10), unit: UnitLength.micrometers),
                       (range: 500.0...630, tolerance: Double(11), unit: UnitLength.micrometers),
                       (range: 630.0...800.0, tolerance: Double(13), unit: UnitLength.micrometers),
                       (range: 800.0...1000.0, tolerance: Double(15), unit: UnitLength.micrometers),
                       (range: 1000.0...1250, tolerance: Double(18), unit: UnitLength.micrometers),
                       (range: 1250.0...1600, tolerance: Double(21), unit: UnitLength.micrometers),
                       (range: 1600.0...2000.0, tolerance: Double(25), unit: UnitLength.micrometers),
                       (range: 2000.0...2500, tolerance: Double(30), unit: UnitLength.micrometers),
                       (range: 2500.0...3150.0, tolerance: Double(36), unit: UnitLength.micrometers),
                       (range: 3150.0...4000, tolerance: Double(45), unit: UnitLength.micrometers),
                       (range: 4000.0...5000.0, tolerance: Double(55), unit: UnitLength.micrometers),
                       (range: 5000.0...6300.0, tolerance: Double(67), unit: UnitLength.micrometers),
                       (range: 6300.0...8000.0, tolerance: Double(84), unit: UnitLength.micrometers)]
    
    private let it3 = [(range: 0.0...3.0, tolerance: Double(2), unit: UnitLength.micrometers),
                       (range: 3.0...6.0, tolerance: Double(2.5), unit: UnitLength.micrometers),
                       (range: 6.0...10.0, tolerance: Double(2.5), unit: UnitLength.micrometers),
                       (range: 10.0...18.0, tolerance: Double(3), unit: UnitLength.micrometers),
                       (range: 18.0...30, tolerance: Double(4), unit: UnitLength.micrometers),
                       (range: 30.0...50.0, tolerance: Double(4), unit: UnitLength.micrometers),
                       (range: 50.0...80.0, tolerance: Double(5), unit: UnitLength.micrometers),
                       (range: 80.0...120.0, tolerance: Double(6), unit: UnitLength.micrometers),
                       (range: 120.0...180.0, tolerance: Double(8), unit: UnitLength.micrometers),
                       (range: 180.0...250.0, tolerance: Double(10), unit: UnitLength.micrometers),
                       (range: 250.0...315.0, tolerance: Double(12), unit: UnitLength.micrometers),
                       (range: 315.0...400, tolerance: Double(13), unit: UnitLength.micrometers),
                       (range: 400.0...500, tolerance: Double(15), unit: UnitLength.micrometers),
                       (range: 500.0...630, tolerance: Double(16), unit: UnitLength.micrometers),
                       (range: 630.0...800.0, tolerance: Double(18), unit: UnitLength.micrometers),
                       (range: 800.0...1000.0, tolerance: Double(21), unit: UnitLength.micrometers),
                       (range: 1000.0...1250, tolerance: Double(24), unit: UnitLength.micrometers),
                       (range: 1250.0...1600, tolerance: Double(29), unit: UnitLength.micrometers),
                       (range: 1600.0...2000.0, tolerance: Double(35), unit: UnitLength.micrometers),
                       (range: 2000.0...2500, tolerance: Double(41), unit: UnitLength.micrometers),
                       (range: 2500.0...3150.0, tolerance: Double(50), unit: UnitLength.micrometers),
                       (range: 3150.0...4000, tolerance: Double(60), unit: UnitLength.micrometers),
                       (range: 4000.0...5000.0, tolerance: Double(74), unit: UnitLength.micrometers),
                       (range: 5000.0...6300.0, tolerance: Double(92), unit: UnitLength.micrometers),
                       (range: 6300.0...8000.0, tolerance: Double(115), unit: UnitLength.micrometers)]
    
    private let it4 = [(range: 0.0...3.0, tolerance: Double(3), unit: UnitLength.micrometers),
                       (range: 3.0...6.0, tolerance: Double(4), unit: UnitLength.micrometers),
                       (range: 6.0...10.0, tolerance: Double(4), unit: UnitLength.micrometers),
                       (range: 10.0...18.0, tolerance: Double(5), unit: UnitLength.micrometers),
                       (range: 18.0...30, tolerance: Double(6), unit: UnitLength.micrometers),
                       (range: 30.0...50.0, tolerance: Double(7), unit: UnitLength.micrometers),
                       (range: 50.0...80.0, tolerance: Double(8), unit: UnitLength.micrometers),
                       (range: 80.0...120.0, tolerance: Double(10), unit: UnitLength.micrometers),
                       (range: 120.0...180.0, tolerance: Double(12), unit: UnitLength.micrometers),
                       (range: 180.0...250.0, tolerance: Double(14), unit: UnitLength.micrometers),
                       (range: 250.0...315.0, tolerance: Double(16), unit: UnitLength.micrometers),
                       (range: 315.0...400, tolerance: Double(18), unit: UnitLength.micrometers),
                       (range: 400.0...500, tolerance: Double(20), unit: UnitLength.micrometers),
                       (range: 500.0...630, tolerance: Double(22), unit: UnitLength.micrometers),
                       (range: 630.0...800.0, tolerance: Double(25), unit: UnitLength.micrometers),
                       (range: 800.0...1000.0, tolerance: Double(29), unit: UnitLength.micrometers),
                       (range: 1000.0...1250, tolerance: Double(34), unit: UnitLength.micrometers),
                       (range: 1250.0...1600, tolerance: Double(40), unit: UnitLength.micrometers),
                       (range: 1600.0...2000.0, tolerance: Double(48), unit: UnitLength.micrometers),
                       (range: 2000.0...2500, tolerance: Double(57), unit: UnitLength.micrometers),
                       (range: 2500.0...3150.0, tolerance: Double(69), unit: UnitLength.micrometers),
                       (range: 3150.0...4000, tolerance: Double(84), unit: UnitLength.micrometers),
                       (range: 4000.0...5000.0, tolerance: Double(100), unit: UnitLength.micrometers),
                       (range: 5000.0...6300.0, tolerance: Double(125), unit: UnitLength.micrometers),
                       (range: 6300.0...8000.0, tolerance: Double(155), unit: UnitLength.micrometers)]
    
    private let it5 = [(range: 0.0...3.0, tolerance: Double(4), unit: UnitLength.micrometers),
                       (range: 3.0...6.0, tolerance: Double(5), unit: UnitLength.micrometers),
                       (range: 6.0...10.0, tolerance: Double(6), unit: UnitLength.micrometers),
                       (range: 10.0...18.0, tolerance: Double(8), unit: UnitLength.micrometers),
                       (range: 18.0...30, tolerance: Double(9), unit: UnitLength.micrometers),
                       (range: 30.0...50.0, tolerance: Double(11), unit: UnitLength.micrometers),
                       (range: 50.0...80.0, tolerance: Double(13), unit: UnitLength.micrometers),
                       (range: 80.0...120.0, tolerance: Double(15), unit: UnitLength.micrometers),
                       (range: 120.0...180.0, tolerance: Double(18), unit: UnitLength.micrometers),
                       (range: 180.0...250.0, tolerance: Double(20), unit: UnitLength.micrometers),
                       (range: 250.0...315.0, tolerance: Double(23), unit: UnitLength.micrometers),
                       (range: 315.0...400, tolerance: Double(25), unit: UnitLength.micrometers),
                       (range: 400.0...500, tolerance: Double(27), unit: UnitLength.micrometers),
                       (range: 500.0...630, tolerance: Double(30), unit: UnitLength.micrometers),
                       (range: 630.0...800.0, tolerance: Double(35), unit: UnitLength.micrometers),
                       (range: 800.0...1000.0, tolerance: Double(40), unit: UnitLength.micrometers),
                       (range: 1000.0...1250, tolerance: Double(46), unit: UnitLength.micrometers),
                       (range: 1250.0...1600, tolerance: Double(54), unit: UnitLength.micrometers),
                       (range: 1600.0...2000.0, tolerance: Double(65), unit: UnitLength.micrometers),
                       (range: 2000.0...2500, tolerance: Double(77), unit: UnitLength.micrometers),
                       (range: 2500.0...3150.0, tolerance: Double(93), unit: UnitLength.micrometers),
                       (range: 3150.0...4000, tolerance: Double(115), unit: UnitLength.micrometers),
                       (range: 4000.0...5000.0, tolerance: Double(140), unit: UnitLength.micrometers),
                       (range: 5000.0...6300.0, tolerance: Double(170), unit: UnitLength.micrometers),
                       (range: 6300.0...8000.0, tolerance: Double(215), unit: UnitLength.micrometers)]
    
    private let it6 = [(range: 0.0...3.0, tolerance: Double(6), unit: UnitLength.micrometers),
                       (range: 3.0...6.0, tolerance: Double(8), unit: UnitLength.micrometers),
                       (range: 6.0...10.0, tolerance: Double(9), unit: UnitLength.micrometers),
                       (range: 10.0...18.0, tolerance: Double(11), unit: UnitLength.micrometers),
                       (range: 18.0...30, tolerance: Double(13), unit: UnitLength.micrometers),
                       (range: 30.0...50.0, tolerance: Double(16), unit: UnitLength.micrometers),
                       (range: 50.0...80.0, tolerance: Double(19), unit: UnitLength.micrometers),
                       (range: 80.0...120.0, tolerance: Double(22), unit: UnitLength.micrometers),
                       (range: 120.0...180.0, tolerance: Double(25), unit: UnitLength.micrometers),
                       (range: 180.0...250.0, tolerance: Double(29), unit: UnitLength.micrometers),
                       (range: 250.0...315.0, tolerance: Double(32), unit: UnitLength.micrometers),
                       (range: 315.0...400, tolerance: Double(36), unit: UnitLength.micrometers),
                       (range: 400.0...500, tolerance: Double(40), unit: UnitLength.micrometers),
                       (range: 500.0...630, tolerance: Double(44), unit: UnitLength.micrometers),
                       (range: 630.0...800.0, tolerance: Double(50), unit: UnitLength.micrometers),
                       (range: 800.0...1000.0, tolerance: Double(56), unit: UnitLength.micrometers),
                       (range: 1000.0...1250, tolerance: Double(66), unit: UnitLength.micrometers),
                       (range: 1250.0...1600, tolerance: Double(78), unit: UnitLength.micrometers),
                       (range: 1600.0...2000.0, tolerance: Double(92), unit: UnitLength.micrometers),
                       (range: 2000.0...2500, tolerance: Double(110), unit: UnitLength.micrometers),
                       (range: 2500.0...3150.0, tolerance: Double(135), unit: UnitLength.micrometers),
                       (range: 3150.0...4000, tolerance: Double(165), unit: UnitLength.micrometers),
                       (range: 4000.0...5000.0, tolerance: Double(200), unit: UnitLength.micrometers),
                       (range: 5000.0...6300.0, tolerance: Double(250), unit: UnitLength.micrometers),
                       (range: 6300.0...8000.0, tolerance: Double(310), unit: UnitLength.micrometers)]
    
    private let it7 = [(range: 0.0...3.0, tolerance: Double(10), unit: UnitLength.micrometers),
                       (range: 3.0...6.0, tolerance: Double(12), unit: UnitLength.micrometers),
                       (range: 6.0...10.0, tolerance: Double(15), unit: UnitLength.micrometers),
                       (range: 10.0...18.0, tolerance: Double(18), unit: UnitLength.micrometers),
                       (range: 18.0...30, tolerance: Double(21), unit: UnitLength.micrometers),
                       (range: 30.0...50.0, tolerance: Double(25), unit: UnitLength.micrometers),
                       (range: 50.0...80.0, tolerance: Double(30), unit: UnitLength.micrometers),
                       (range: 80.0...120.0, tolerance: Double(35), unit: UnitLength.micrometers),
                       (range: 120.0...180.0, tolerance: Double(40), unit: UnitLength.micrometers),
                       (range: 180.0...250.0, tolerance: Double(46), unit: UnitLength.micrometers),
                       (range: 250.0...315.0, tolerance: Double(52), unit: UnitLength.micrometers),
                       (range: 315.0...400, tolerance: Double(57), unit: UnitLength.micrometers),
                       (range: 400.0...500, tolerance: Double(63), unit: UnitLength.micrometers),
                       (range: 500.0...630, tolerance: Double(70), unit: UnitLength.micrometers),
                       (range: 630.0...800.0, tolerance: Double(80), unit: UnitLength.micrometers),
                       (range: 800.0...1000.0, tolerance: Double(90), unit: UnitLength.micrometers),
                       (range: 1000.0...1250, tolerance: Double(105), unit: UnitLength.micrometers),
                       (range: 1250.0...1600, tolerance: Double(125), unit: UnitLength.micrometers),
                       (range: 1600.0...2000.0, tolerance: Double(150), unit: UnitLength.micrometers),
                       (range: 2000.0...2500, tolerance: Double(175), unit: UnitLength.micrometers),
                       (range: 2500.0...3150.0, tolerance: Double(210), unit: UnitLength.micrometers),
                       (range: 3150.0...4000, tolerance: Double(260), unit: UnitLength.micrometers),
                       (range: 4000.0...5000.0, tolerance: Double(320), unit: UnitLength.micrometers),
                       (range: 5000.0...6300.0, tolerance: Double(400), unit: UnitLength.micrometers),
                       (range: 6300.0...8000.0, tolerance: Double(490), unit: UnitLength.micrometers)]
    
    private let it8 = [(range: 0.0...3.0, tolerance: Double(14), unit: UnitLength.micrometers),
                       (range: 3.0...6.0, tolerance: Double(18), unit: UnitLength.micrometers),
                       (range: 6.0...10.0, tolerance: Double(22), unit: UnitLength.micrometers),
                       (range: 10.0...18.0, tolerance: Double(27), unit: UnitLength.micrometers),
                       (range: 18.0...30, tolerance: Double(33), unit: UnitLength.micrometers),
                       (range: 30.0...50.0, tolerance: Double(39), unit: UnitLength.micrometers),
                       (range: 50.0...80.0, tolerance: Double(46), unit: UnitLength.micrometers),
                       (range: 80.0...120.0, tolerance: Double(54), unit: UnitLength.micrometers),
                       (range: 120.0...180.0, tolerance: Double(63), unit: UnitLength.micrometers),
                       (range: 180.0...250.0, tolerance: Double(72), unit: UnitLength.micrometers),
                       (range: 250.0...315.0, tolerance: Double(81), unit: UnitLength.micrometers),
                       (range: 315.0...400, tolerance: Double(89), unit: UnitLength.micrometers),
                       (range: 400.0...500, tolerance: Double(97), unit: UnitLength.micrometers),
                       (range: 500.0...630, tolerance: Double(110), unit: UnitLength.micrometers),
                       (range: 630.0...800.0, tolerance: Double(125), unit: UnitLength.micrometers),
                       (range: 800.0...1000.0, tolerance: Double(140), unit: UnitLength.micrometers),
                       (range: 1000.0...1250, tolerance: Double(165), unit: UnitLength.micrometers),
                       (range: 1250.0...1600, tolerance: Double(195), unit: UnitLength.micrometers),
                       (range: 1600.0...2000.0, tolerance: Double(230), unit: UnitLength.micrometers),
                       (range: 2000.0...2500, tolerance: Double(280), unit: UnitLength.micrometers),
                       (range: 2500.0...3150.0, tolerance: Double(330), unit: UnitLength.micrometers),
                       (range: 3150.0...4000, tolerance: Double(410), unit: UnitLength.micrometers),
                       (range: 4000.0...5000.0, tolerance: Double(500), unit: UnitLength.micrometers),
                       (range: 5000.0...6300.0, tolerance: Double(620), unit: UnitLength.micrometers),
                       (range: 6300.0...8000.0, tolerance: Double(760), unit: UnitLength.micrometers)]
    
    private let it9 = [(range: 0.0...3.0, tolerance: Double(25), unit: UnitLength.micrometers),
                       (range: 3.0...6.0, tolerance: Double(30), unit: UnitLength.micrometers),
                       (range: 6.0...10.0, tolerance: Double(36), unit: UnitLength.micrometers),
                       (range: 10.0...18.0, tolerance: Double(43), unit: UnitLength.micrometers),
                       (range: 18.0...30, tolerance: Double(52), unit: UnitLength.micrometers),
                       (range: 30.0...50.0, tolerance: Double(62), unit: UnitLength.micrometers),
                       (range: 50.0...80.0, tolerance: Double(74), unit: UnitLength.micrometers),
                       (range: 80.0...120.0, tolerance: Double(87), unit: UnitLength.micrometers),
                       (range: 120.0...180.0, tolerance: Double(100), unit: UnitLength.micrometers),
                       (range: 180.0...250.0, tolerance: Double(115), unit: UnitLength.micrometers),
                       (range: 250.0...315.0, tolerance: Double(130), unit: UnitLength.micrometers),
                       (range: 315.0...400, tolerance: Double(140), unit: UnitLength.micrometers),
                       (range: 400.0...500, tolerance: Double(155), unit: UnitLength.micrometers),
                       (range: 500.0...630, tolerance: Double(175), unit: UnitLength.micrometers),
                       (range: 630.0...800.0, tolerance: Double(200), unit: UnitLength.micrometers),
                       (range: 800.0...1000.0, tolerance: Double(230), unit: UnitLength.micrometers),
                       (range: 1000.0...1250, tolerance: Double(260), unit: UnitLength.micrometers),
                       (range: 1250.0...1600, tolerance: Double(310), unit: UnitLength.micrometers),
                       (range: 1600.0...2000.0, tolerance: Double(370), unit: UnitLength.micrometers),
                       (range: 2000.0...2500, tolerance: Double(440), unit: UnitLength.micrometers),
                       (range: 2500.0...3150.0, tolerance: Double(540), unit: UnitLength.micrometers),
                       (range: 3150.0...4000, tolerance: Double(660), unit: UnitLength.micrometers),
                       (range: 4000.0...5000.0, tolerance: Double(800), unit: UnitLength.micrometers),
                       (range: 5000.0...6300.0, tolerance: Double(980), unit: UnitLength.micrometers),
                       (range: 6300.0...8000.0, tolerance: Double(1200), unit: UnitLength.micrometers)]
    
    private let it10 = [(range: 0.0...3.0, tolerance: Double(40), unit: UnitLength.micrometers),
                        (range: 3.0...6.0, tolerance: Double(48), unit: UnitLength.micrometers),
                        (range: 6.0...10.0, tolerance: Double(58), unit: UnitLength.micrometers),
                        (range: 10.0...18.0, tolerance: Double(70), unit: UnitLength.micrometers),
                        (range: 18.0...30, tolerance: Double(84), unit: UnitLength.micrometers),
                        (range: 30.0...50.0, tolerance: Double(100), unit: UnitLength.micrometers),
                        (range: 50.0...80.0, tolerance: Double(120), unit: UnitLength.micrometers),
                        (range: 80.0...120.0, tolerance: Double(140), unit: UnitLength.micrometers),
                        (range: 120.0...180.0, tolerance: Double(160), unit: UnitLength.micrometers),
                        (range: 180.0...250.0, tolerance: Double(185), unit: UnitLength.micrometers),
                        (range: 250.0...315.0, tolerance: Double(210), unit: UnitLength.micrometers),
                        (range: 315.0...400, tolerance: Double(230), unit: UnitLength.micrometers),
                        (range: 400.0...500, tolerance: Double(250), unit: UnitLength.micrometers),
                        (range: 500.0...630, tolerance: Double(280), unit: UnitLength.micrometers),
                        (range: 630.0...800.0, tolerance: Double(320), unit: UnitLength.micrometers),
                        (range: 800.0...1000.0, tolerance: Double(360), unit: UnitLength.micrometers),
                        (range: 1000.0...1250, tolerance: Double(420), unit: UnitLength.micrometers),
                        (range: 1250.0...1600, tolerance: Double(500), unit: UnitLength.micrometers),
                        (range: 1600.0...2000.0, tolerance: Double(600), unit: UnitLength.micrometers),
                        (range: 2000.0...2500, tolerance: Double(700), unit: UnitLength.micrometers),
                        (range: 2500.0...3150.0, tolerance: Double(860), unit: UnitLength.micrometers),
                        (range: 3150.0...4000, tolerance: Double(1050), unit: UnitLength.micrometers),
                        (range: 4000.0...5000.0, tolerance: Double(1300), unit: UnitLength.micrometers),
                        (range: 5000.0...6300.0, tolerance: Double(1550), unit: UnitLength.micrometers),
                        (range: 6300.0...8000.0, tolerance: Double(1950), unit: UnitLength.micrometers)]
    
    private let it11 = [(range: 0.0...3.0, tolerance: Double(60), unit: UnitLength.micrometers),
                        (range: 3.0...6.0, tolerance: Double(75), unit: UnitLength.micrometers),
                        (range: 6.0...10.0, tolerance: Double(90), unit: UnitLength.micrometers),
                        (range: 10.0...18.0, tolerance: Double(110), unit: UnitLength.micrometers),
                        (range: 18.0...30, tolerance: Double(130), unit: UnitLength.micrometers),
                        (range: 30.0...50.0, tolerance: Double(160), unit: UnitLength.micrometers),
                        (range: 50.0...80.0, tolerance: Double(190), unit: UnitLength.micrometers),
                        (range: 80.0...120.0, tolerance: Double(220), unit: UnitLength.micrometers),
                        (range: 120.0...180.0, tolerance: Double(250), unit: UnitLength.micrometers),
                        (range: 180.0...250.0, tolerance: Double(290), unit: UnitLength.micrometers),
                        (range: 250.0...315.0, tolerance: Double(320), unit: UnitLength.micrometers),
                        (range: 315.0...400, tolerance: Double(360), unit: UnitLength.micrometers),
                        (range: 400.0...500, tolerance: Double(400), unit: UnitLength.micrometers),
                        (range: 500.0...630, tolerance: Double(440), unit: UnitLength.micrometers),
                        (range: 630.0...800.0, tolerance: Double(500), unit: UnitLength.micrometers),
                        (range: 800.0...1000.0, tolerance: Double(560), unit: UnitLength.micrometers),
                        (range: 1000.0...1250, tolerance: Double(660), unit: UnitLength.micrometers),
                        (range: 1250.0...1600, tolerance: Double(780), unit: UnitLength.micrometers),
                        (range: 1600.0...2000.0, tolerance: Double(920), unit: UnitLength.micrometers),
                        (range: 2000.0...2500, tolerance: Double(1100), unit: UnitLength.micrometers),
                        (range: 2500.0...3150.0, tolerance: Double(1350), unit: UnitLength.micrometers),
                        (range: 3150.0...4000, tolerance: Double(1650), unit: UnitLength.micrometers),
                        (range: 4000.0...5000.0, tolerance: Double(2000), unit: UnitLength.micrometers),
                        (range: 5000.0...6300.0, tolerance: Double(2500), unit: UnitLength.micrometers),
                        (range: 6300.0...8000.0, tolerance: Double(3100), unit: UnitLength.micrometers)]
    
    private let it12 = [(range: 0.0...3.0, tolerance: 0.1, unit: UnitLength.millimeters),
                        (range: 3.0...6.0, tolerance: 0.12, unit: UnitLength.millimeters),
                        (range: 6.0...10.0, tolerance: 0.15, unit: UnitLength.millimeters),
                        (range: 10.0...18.0, tolerance: 0.18, unit: UnitLength.millimeters),
                        (range: 18.0...30, tolerance: 0.21, unit: UnitLength.millimeters),
                        (range: 30.0...50.0, tolerance: 0.25, unit: UnitLength.millimeters),
                        (range: 50.0...80.0, tolerance: 0.3, unit: UnitLength.millimeters),
                        (range: 80.0...120.0, tolerance: 0.35, unit: UnitLength.millimeters),
                        (range: 120.0...180.0, tolerance: 0.4, unit: UnitLength.millimeters),
                        (range: 180.0...250.0, tolerance: 0.46, unit: UnitLength.millimeters),
                        (range: 250.0...315.0, tolerance: 0.52, unit: UnitLength.millimeters),
                        (range: 315.0...400, tolerance: 0.57, unit: UnitLength.millimeters),
                        (range: 400.0...500, tolerance: 0.63, unit: UnitLength.millimeters),
                        (range: 500.0...630, tolerance: 0.7, unit: UnitLength.millimeters),
                        (range: 630.0...800.0, tolerance: 0.8, unit: UnitLength.millimeters),
                        (range: 800.0...1000.0, tolerance: 0.9, unit: UnitLength.millimeters),
                        (range: 1000.0...1250, tolerance: 1.05, unit: UnitLength.millimeters),
                        (range: 1250.0...1600, tolerance: 1.25, unit: UnitLength.millimeters),
                        (range: 1600.0...2000.0, tolerance: 1.5, unit: UnitLength.millimeters),
                        (range: 2000.0...2500, tolerance: 1.75, unit: UnitLength.millimeters),
                        (range: 2500.0...3150.0, tolerance: 2.1, unit: UnitLength.millimeters),
                        (range: 3150.0...4000, tolerance: 2.6, unit: UnitLength.millimeters),
                        (range: 4000.0...5000.0, tolerance: 3.2, unit: UnitLength.millimeters),
                        (range: 5000.0...6300.0, tolerance: 4.0, unit: UnitLength.millimeters),
                        (range: 6300.0...8000.0, tolerance: 4.9, unit: UnitLength.millimeters)]
    
    private let it13 = [(range: 0.0...3.0, tolerance: 0.14, unit: UnitLength.millimeters),
                        (range: 3.0...6.0, tolerance: 0.18, unit: UnitLength.millimeters),
                        (range: 6.0...10.0, tolerance: 0.22, unit: UnitLength.millimeters),
                        (range: 10.0...18.0, tolerance: 0.27, unit: UnitLength.millimeters),
                        (range: 18.0...30, tolerance: 0.33, unit: UnitLength.millimeters),
                        (range: 30.0...50.0, tolerance: 0.39, unit: UnitLength.millimeters),
                        (range: 50.0...80.0, tolerance: 0.46, unit: UnitLength.millimeters),
                        (range: 80.0...120.0, tolerance: 0.54, unit: UnitLength.millimeters),
                        (range: 120.0...180.0, tolerance: 0.63, unit: UnitLength.millimeters),
                        (range: 180.0...250.0, tolerance: 0.72, unit: UnitLength.millimeters),
                        (range: 250.0...315.0, tolerance: 0.81, unit: UnitLength.millimeters),
                        (range: 315.0...400, tolerance: 0.89, unit: UnitLength.millimeters),
                        (range: 400.0...500, tolerance: 0.97, unit: UnitLength.millimeters),
                        (range: 500.0...630, tolerance: 1.1, unit: UnitLength.millimeters),
                        (range: 630.0...800.0, tolerance: 1.25, unit: UnitLength.millimeters),
                        (range: 800.0...1000.0, tolerance: 1.4, unit: UnitLength.millimeters),
                        (range: 1000.0...1250, tolerance: 1.65, unit: UnitLength.millimeters),
                        (range: 1250.0...1600, tolerance: 1.95, unit: UnitLength.millimeters),
                        (range: 1600.0...2000.0, tolerance: 2.3, unit: UnitLength.millimeters),
                        (range: 2000.0...2500, tolerance: 2.8, unit: UnitLength.millimeters),
                        (range: 2500.0...3150.0, tolerance: 3.3, unit: UnitLength.millimeters),
                        (range: 3150.0...4000, tolerance: 4.1, unit: UnitLength.millimeters),
                        (range: 4000.0...5000.0, tolerance: 5.0, unit: UnitLength.millimeters),
                        (range: 5000.0...6300.0, tolerance: 6.2, unit: UnitLength.millimeters),
                        (range: 6300.0...8000.0, tolerance: 7.6, unit: UnitLength.millimeters)]
    
    private let it14 = [(range: 0.0...3.0, tolerance: 0.25, unit: UnitLength.millimeters),
                        (range: 3.0...6.0, tolerance: 0.3, unit: UnitLength.millimeters),
                        (range: 6.0...10.0, tolerance: 0.36, unit: UnitLength.millimeters),
                        (range: 10.0...18.0, tolerance: 0.43, unit: UnitLength.millimeters),
                        (range: 18.0...30, tolerance: 0.52, unit: UnitLength.millimeters),
                        (range: 30.0...50.0, tolerance: 0.62, unit: UnitLength.millimeters),
                        (range: 50.0...80.0, tolerance: 0.74, unit: UnitLength.millimeters),
                        (range: 80.0...120.0, tolerance: 0.87, unit: UnitLength.millimeters),
                        (range: 120.0...180.0, tolerance: 1.0, unit: UnitLength.millimeters),
                        (range: 180.0...250.0, tolerance: 1.15, unit: UnitLength.millimeters),
                        (range: 250.0...315.0, tolerance: 1.3, unit: UnitLength.millimeters),
                        (range: 315.0...400, tolerance: 1.4, unit: UnitLength.millimeters),
                        (range: 400.0...500, tolerance: 1.55, unit: UnitLength.millimeters),
                        (range: 500.0...630, tolerance: 1.75, unit: UnitLength.millimeters),
                        (range: 630.0...800.0, tolerance: 2.0, unit: UnitLength.millimeters),
                        (range: 800.0...1000.0, tolerance: 2.3, unit: UnitLength.millimeters),
                        (range: 1000.0...1250, tolerance: 2.6, unit: UnitLength.millimeters),
                        (range: 1250.0...1600, tolerance: 3.1, unit: UnitLength.millimeters),
                        (range: 1600.0...2000.0, tolerance: 3.7, unit: UnitLength.millimeters),
                        (range: 2000.0...2500, tolerance: 4.4, unit: UnitLength.millimeters),
                        (range: 2500.0...3150.0, tolerance: 5.4, unit: UnitLength.millimeters),
                        (range: 3150.0...4000, tolerance: 6.6, unit: UnitLength.millimeters),
                        (range: 4000.0...5000.0, tolerance: 8.0, unit: UnitLength.millimeters),
                        (range: 5000.0...6300.0, tolerance: 9.8, unit: UnitLength.millimeters),
                        (range: 6300.0...8000.0, tolerance: 12.0, unit: UnitLength.millimeters)]
    
    private let it15 = [(range: 0.0...3.0, tolerance: 0.4, unit: UnitLength.millimeters),
                        (range: 3.0...6.0, tolerance: 0.48, unit: UnitLength.millimeters),
                        (range: 6.0...10.0, tolerance: 0.58, unit: UnitLength.millimeters),
                        (range: 10.0...18.0, tolerance: 0.7, unit: UnitLength.millimeters),
                        (range: 18.0...30, tolerance: 0.84, unit: UnitLength.millimeters),
                        (range: 30.0...50.0, tolerance: 1.0, unit: UnitLength.millimeters),
                        (range: 50.0...80.0, tolerance: 1.2, unit: UnitLength.millimeters),
                        (range: 80.0...120.0, tolerance: 1.4, unit: UnitLength.millimeters),
                        (range: 120.0...180.0, tolerance: 1.6, unit: UnitLength.millimeters),
                        (range: 180.0...250.0, tolerance: 1.85, unit: UnitLength.millimeters),
                        (range: 250.0...315.0, tolerance: 2.1, unit: UnitLength.millimeters),
                        (range: 315.0...400, tolerance: 2.3, unit: UnitLength.millimeters),
                        (range: 400.0...500, tolerance: 2.5, unit: UnitLength.millimeters),
                        (range: 500.0...630, tolerance: 2.8, unit: UnitLength.millimeters),
                        (range: 630.0...800.0, tolerance: 3.2, unit: UnitLength.millimeters),
                        (range: 800.0...1000.0, tolerance: 3.6, unit: UnitLength.millimeters),
                        (range: 1000.0...1250, tolerance: 4.2, unit: UnitLength.millimeters),
                        (range: 1250.0...1600, tolerance: 5.0, unit: UnitLength.millimeters),
                        (range: 1600.0...2000.0, tolerance: 6.0, unit: UnitLength.millimeters),
                        (range: 2000.0...2500, tolerance: 7.0, unit: UnitLength.millimeters),
                        (range: 2500.0...3150.0, tolerance: 8.6, unit: UnitLength.millimeters),
                        (range: 3150.0...4000, tolerance: 10.5, unit: UnitLength.millimeters),
                        (range: 4000.0...5000.0, tolerance: 13.0, unit: UnitLength.millimeters),
                        (range: 5000.0...6300.0, tolerance: 15.5, unit: UnitLength.millimeters),
                        (range: 6300.0...8000.0, tolerance: 19.5, unit: UnitLength.millimeters)]
    
    private let it16 = [(range: 0.0...3.0, tolerance: 0.6, unit: UnitLength.millimeters),
                        (range: 3.0...6.0, tolerance: 0.75, unit: UnitLength.millimeters),
                        (range: 6.0...10.0, tolerance: 0.9, unit: UnitLength.millimeters),
                        (range: 10.0...18.0, tolerance: 1.1, unit: UnitLength.millimeters),
                        (range: 18.0...30, tolerance: 1.3, unit: UnitLength.millimeters),
                        (range: 30.0...50.0, tolerance: 1.6, unit: UnitLength.millimeters),
                        (range: 50.0...80.0, tolerance: 1.9, unit: UnitLength.millimeters),
                        (range: 80.0...120.0, tolerance: 2.2, unit: UnitLength.millimeters),
                        (range: 120.0...180.0, tolerance: 2.5, unit: UnitLength.millimeters),
                        (range: 180.0...250.0, tolerance: 2.9, unit: UnitLength.millimeters),
                        (range: 250.0...315.0, tolerance: 3.2, unit: UnitLength.millimeters),
                        (range: 315.0...400, tolerance: 3.6, unit: UnitLength.millimeters),
                        (range: 400.0...500, tolerance: 4.0, unit: UnitLength.millimeters),
                        (range: 500.0...630, tolerance: 4.4, unit: UnitLength.millimeters),
                        (range: 630.0...800.0, tolerance: 5.0, unit: UnitLength.millimeters),
                        (range: 800.0...1000.0, tolerance: 5.6, unit: UnitLength.millimeters),
                        (range: 1000.0...1250, tolerance: 6.6, unit: UnitLength.millimeters),
                        (range: 1250.0...1600, tolerance: 7.8, unit: UnitLength.millimeters),
                        (range: 1600.0...2000.0, tolerance: 9.2, unit: UnitLength.millimeters),
                        (range: 2000.0...2500, tolerance: 11.0, unit: UnitLength.millimeters),
                        (range: 2500.0...3150.0, tolerance: 13.5, unit: UnitLength.millimeters),
                        (range: 3150.0...4000, tolerance: 16.5, unit: UnitLength.millimeters),
                        (range: 4000.0...5000.0, tolerance: 20.0, unit: UnitLength.millimeters),
                        (range: 5000.0...6300.0, tolerance: 25.0, unit: UnitLength.millimeters),
                        (range: 6300.0...8000.0, tolerance: 31.0, unit: UnitLength.millimeters)]
    
    private let it17 = [(range: 0.0...3.0, tolerance: 1.0, unit: UnitLength.millimeters),
                        (range: 3.0...6.0, tolerance: 1.2, unit: UnitLength.millimeters),
                        (range: 6.0...10.0, tolerance: 1.5, unit: UnitLength.millimeters),
                        (range: 10.0...18.0, tolerance: 1.8, unit: UnitLength.millimeters),
                        (range: 18.0...30, tolerance: 2.1, unit: UnitLength.millimeters),
                        (range: 30.0...50.0, tolerance: 2.5, unit: UnitLength.millimeters),
                        (range: 50.0...80.0, tolerance: 3.0, unit: UnitLength.millimeters),
                        (range: 80.0...120.0, tolerance: 3.5, unit: UnitLength.millimeters),
                        (range: 120.0...180.0, tolerance: 4.0, unit: UnitLength.millimeters),
                        (range: 180.0...250.0, tolerance: 4.6, unit: UnitLength.millimeters),
                        (range: 250.0...315.0, tolerance: 5.2, unit: UnitLength.millimeters),
                        (range: 315.0...400, tolerance: 5.7, unit: UnitLength.millimeters),
                        (range: 400.0...500, tolerance: 6.3, unit: UnitLength.millimeters),
                        (range: 500.0...630, tolerance: 7.0, unit: UnitLength.millimeters),
                        (range: 630.0...800.0, tolerance: 8.0, unit: UnitLength.millimeters),
                        (range: 800.0...1000.0, tolerance: 9.0, unit: UnitLength.millimeters),
                        (range: 1000.0...1250, tolerance: 10.5, unit: UnitLength.millimeters),
                        (range: 1250.0...1600, tolerance: 12.5, unit: UnitLength.millimeters),
                        (range: 1600.0...2000.0, tolerance: 15.0, unit: UnitLength.millimeters),
                        (range: 2000.0...2500, tolerance: 17.5, unit: UnitLength.millimeters),
                        (range: 2500.0...3150.0, tolerance: 21.0, unit: UnitLength.millimeters),
                        (range: 3150.0...4000, tolerance: 26.0, unit: UnitLength.millimeters),
                        (range: 4000.0...5000.0, tolerance: 32.0, unit: UnitLength.millimeters),
                        (range: 5000.0...6300.0, tolerance: 40.0, unit: UnitLength.millimeters),
                        (range: 6300.0...8000.0, tolerance: 49.0, unit: UnitLength.millimeters)]
    
    private let it18 = [(range: 0.0...3.0, tolerance: 1.4, unit: UnitLength.millimeters),
                        (range: 3.0...6.0, tolerance: 1.8, unit: UnitLength.millimeters),
                        (range: 6.0...10.0, tolerance: 2.2, unit: UnitLength.millimeters),
                        (range: 10.0...18.0, tolerance: 2.7, unit: UnitLength.millimeters),
                        (range: 18.0...30, tolerance: 3.3, unit: UnitLength.millimeters),
                        (range: 30.0...50.0, tolerance: 3.9, unit: UnitLength.millimeters),
                        (range: 50.0...80.0, tolerance: 4.6, unit: UnitLength.millimeters),
                        (range: 80.0...120.0, tolerance: 5.4, unit: UnitLength.millimeters),
                        (range: 120.0...180.0, tolerance: 6.3, unit: UnitLength.millimeters),
                        (range: 180.0...250.0, tolerance: 7.2, unit: UnitLength.millimeters),
                        (range: 250.0...315.0, tolerance: 8.1, unit: UnitLength.millimeters),
                        (range: 315.0...400, tolerance: 8.9, unit: UnitLength.millimeters),
                        (range: 400.0...500, tolerance: 9.7, unit: UnitLength.millimeters),
                        (range: 500.0...630, tolerance: 11.0, unit: UnitLength.millimeters),
                        (range: 630.0...800.0, tolerance: 12.5, unit: UnitLength.millimeters),
                        (range: 800.0...1000.0, tolerance: 14.0, unit: UnitLength.millimeters),
                        (range: 1000.0...1250, tolerance: 16.5, unit: UnitLength.millimeters),
                        (range: 1250.0...1600, tolerance: 19.5, unit: UnitLength.millimeters),
                        (range: 1600.0...2000.0, tolerance: 23.0, unit: UnitLength.millimeters),
                        (range: 2000.0...2500, tolerance: 28.0, unit: UnitLength.millimeters),
                        (range: 2500.0...3150.0, tolerance: 33.0, unit: UnitLength.millimeters),
                        (range: 3150.0...4000, tolerance: 41.0, unit: UnitLength.millimeters),
                        (range: 4000.0...5000.0, tolerance: 50.0, unit: UnitLength.millimeters),
                        (range: 5000.0...6300.0, tolerance: 62.0, unit: UnitLength.millimeters),
                        (range: 6300.0...8000.0, tolerance: 76.0, unit: UnitLength.millimeters)]
    
    var getAllDimensions: Int {
        get {
            if sortedDimensions.isEmpty {
                return self.searchState ? 0 : dimensions.count
            } else {
                return sortedDimensions.count
            }
        }
    }
    
    var getStateToleranceValue: ChosenTolerance {
        get {
            return stateTolerance ?? .it12
        }
    }
    
    init() {
        setupDimensions()
    }
    
    //MARK: - Methods
    
    func setTolerance(tolerance: ChosenTolerance) {
        stateTolerance = tolerance
    }
    
    func getElement(with element: Int) -> String {
        if sortedDimensions.isEmpty {
            return dimensions[element].name
        } else {
            return sortedDimensions[element].name
        }
    }
    
    func getToleranceValue(with element: Int) -> String {
        if sortedDimensions.isEmpty {
            return String(dimensions[element].tolerance ?? 0.0) + " " + String(dimensions[element].unit?.symbol ?? "unknown")
        } else {
            return String(sortedDimensions[element].tolerance ?? 0.0) + " " + String(sortedDimensions[element].unit?.symbol ?? "unknown")
        }
    }
    
    func getValue(with element: Int) -> (tolerance: Double, symbol: String) {
        
        if sortedDimensions.isEmpty {
            let valueElement = dimensions[element].tolerance ?? 0.0
            let symbol = dimensions[element].unit?.symbol ?? "unknown"
            
            let toleranceTuple = (tolerance: valueElement, symbol: symbol)
            
            return toleranceTuple
        } else {
            let valueElement = sortedDimensions[element].tolerance ?? 0.0
            let symbol = sortedDimensions[element].unit?.symbol ?? "unknown"
            
            let toleranceTuple = (tolerance: valueElement, symbol: symbol)
            
            return toleranceTuple

        }
        
    }
    
    private func setupDimensions() {
        dictionaryTolerance[.it01] = it01
        dictionaryTolerance[.it0] = it0
        dictionaryTolerance[.it1] = it1
        dictionaryTolerance[.it2] = it2
        dictionaryTolerance[.it3] = it3
        dictionaryTolerance[.it4] = it4
        dictionaryTolerance[.it5] = it5
        dictionaryTolerance[.it6] = it6
        dictionaryTolerance[.it7] = it7
        dictionaryTolerance[.it8] = it8
        dictionaryTolerance[.it9] = it9
        dictionaryTolerance[.it10] = it10
        dictionaryTolerance[.it11] = it11
        dictionaryTolerance[.it12] = it12
        dictionaryTolerance[.it13] = it13
        dictionaryTolerance[.it14] = it14
        dictionaryTolerance[.it15] = it15
        dictionaryTolerance[.it16] = it16
        dictionaryTolerance[.it17] = it17
        dictionaryTolerance[.it18] = it18
        
        installRangeAndToleranceInDimensions()
        
    }
    
    func setBuffers() {
        self.bufferChoseFieldState = self.stateTolerance
    }
    
    func setAllDimensionsFromBuffers() {
        self.stateTolerance = self.bufferChoseFieldState

    }
    
    func clearBuffers() {
        self.bufferChoseFieldState = nil
    }
    
    private func installRangeAndToleranceInDimensions() {
        guard let state = stateTolerance else { return }
        let arrayFromDictionary = dictionaryTolerance[state]

        for index in 0..<dimensions.count {
            dimensions[index].range = arrayFromDictionary?[index].range
            dimensions[index].tolerance = arrayFromDictionary?[index].tolerance
            dimensions[index].unit = arrayFromDictionary?[index].unit
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension DataStore: UserSearchingDimension {
    
    func tolerance(in size: String) {
        
        var sizeFromString = size.replacingOccurrences(of: ",", with: ".", options: .literal, range: nil)
        
        if sizeFromString.isEmpty {
            self.searchState = false
        }
        
        if sizeFromString.last == "." || sizeFromString.last == "," {
            sizeFromString += "0"
        }
        
        let dimensionValue = Double(sizeFromString)
        sortedDimensions = []
        
        for dimension in dimensions {
            
            if sizeFromString.count > 0 && dimension.range?.contains(dimensionValue!) == true {
                sortedDimensions.append(dimension)
                self.searchState = true
            }
            
        }
        
        if sortedDimensions.count>1 {
            sortedDimensions.removeLast()
        }
        
    }
    
    
}

extension Notification.Name {
    static let didToleranceChange = Notification.Name("didToleranceChange")
    static let didHoleDimensionsChange = Notification.Name("didHoleDimensionsChange")
}
