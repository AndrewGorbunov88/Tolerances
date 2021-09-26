//
//  ToleranceCases.swift
//  Tolerances
//
//  Created by Андрей Горбунов on 25.09.2021.
//

import Foundation

enum ChosenTolerance: String, CaseIterable {
    case it01 = "IT01"
    case it0 = "IT0"
    case it1 = "IT1"
    case it2 = "IT2"
    case it3 = "IT3"
    case it4 = "IT4"
    case it5 = "IT5"
    case it6 = "IT6"
    case it7 = "IT7"
    case it8 = "IT8"
    case it9 = "IT9"
    case it10 = "IT10"
    case it11 = "IT11"
    case it12 = "IT12"
    case it13 = "IT13"
    case it14 = "IT14"
    case it15 = "IT15"
    case it16 = "IT16"
    case it17 = "IT17"
    case it18 = "IT18"
}

protocol Fields {
    
}

enum FieldState {
    case hole
    case shaft
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
    case x = "x"
    case z = "z"
}
