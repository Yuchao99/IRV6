//
//  configurarion.swift
//  IRRemote_V6
//
//  Created by Yuchao Chen on 5/2/16.
//  Copyright © 2016 Yuchao Chen. All rights reserved.
//

import Foundation

class Configuration{
    
    enum settingTypes {
        case rampUP
        case delayToOff
        case rampDown
        case maxDimming
        case minDimming
        case sensitivity
        case lightSensor
        case other
        init(){
            self = .other
        }
    }
    
    let ru = 2
    let rd = 3
    let delM = 11
    let delS = 12
    let minLux = 9
    let maxLux = 8
    let minDim = 6
    let maxDim = 5
    let sens = 7
    
    var ruValue: Int!
    var rdValue: Int!
    var delValue: Int!
    var maxDimValue: Int!
    var minDimValue: Int!
    var sensValue: Int!
    var maxLuxValue: Int!
    var minLuxValue: Int!
    var lensValue: Int!
    var alsValue: Int!
    
    init(){
        ruValue = 4
        rdValue = 5
        delValue = 15
        maxDimValue = 80
        minDimValue = 1
        sensValue = 100
        maxLuxValue = 56
        minLuxValue = 10
        lensValue = 0
        alsValue = 0
    }

}