//
//  configurarion.swift
//  IRRemote_V6
//
//  Created by Yuchao Chen on 5/2/16.
//  Copyright © 2016 Yuchao Chen. All rights reserved.
//

import Foundation

class Configuration{
    
    enum settingTypes: Int {
        case rampUP
        case delayToOff
        case delayToOffM
        case delayToOffS
        case rampDown
        case maxDimming
        case minDimming
        case sensitivity
        case lightSensor
        case maxLuxValue
        //case minLuxValue
        case other
        init(){
            self = .other
        }
        var value: Int{
            switch self {
            case .rampUP:
                return 2
            case .delayToOffM:
                return 11
            case .delayToOffS:
                return 12
            case .rampDown:
                return 3
            case .maxDimming:
                return 5
            case .minDimming:
                return 6
            case .sensitivity:
                return 7
            case .maxLuxValue:
                return 8
//            case .minLuxValue:
//                return 6
            default:
                return 0
            }
        }
    }
    
//    let ru = 2
//    let rd = 3
//    let delM = 11
//    let delS = 12
//    let minLux = 9
//    let maxDim = 5
//    let sens = 7
//    let maxLux = 8
//    let minDim = 6
    
    var ruValue: Int!
    var rdValue: Int!
    var delMValue: Int!
    var delSValue: Int!
    var maxDimValue: Int!
    var minDimValue: Int!
    var sensValue: Int!
    //var lensValue: Int!
    var alsValue: Bool!
    var maxLuxValue: Int!
    //var minLuxValue: Int!
    
    init(){
        ruValue = 4
        rdValue = 5
        delMValue = 0
        delSValue = 15
        maxDimValue = 80
        minDimValue = 1
        sensValue = 100
        maxLuxValue = 56
        //minLuxValue = 10
        //lensValue = 0
        alsValue = false
    }

}