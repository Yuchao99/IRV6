//
//  configurarion.swift
//  IRRemote_V6
//
//  Created by Yuchao Chen on 5/2/16.
//  Copyright © 2016 Yuchao Chen. All rights reserved.
//

import Foundation

class Configuration: NSObject, NSCoding{
    
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
        case diff
        case minSlope
        case maxSlope
        case keyMod
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
            case .diff:
                return 4096
            case .minSlope:
                return 4352
            case .maxSlope:
                return 4608
            case .keyMod:
                return 4864
//            case .minLuxValue:
//                return 6
            default:
                return 0
            }
        }
    }
    
    var name: String!
    
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
    var diffValue: Int!
    var minSlopeValue: Int!
    var maxSlopeValue: Int!
    var keyModValue: Int!
    
    override init(){
        
        name = "Default"
        
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
        diffValue = 12000
        minSlopeValue = 200
        maxSlopeValue = 2000
        keyModValue = 11111
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(ruValue, forKey: "ruValue")
        aCoder.encodeObject(rdValue, forKey: "rdValue")
        aCoder.encodeObject(delMValue, forKey: "delMValue")
        aCoder.encodeObject(delSValue, forKey: "delSValue")
        aCoder.encodeObject(maxDimValue, forKey: "maxDimValue")
        aCoder.encodeObject(minDimValue, forKey: "minDimValue")
        aCoder.encodeObject(sensValue, forKey: "sensValue")
        aCoder.encodeObject(maxLuxValue, forKey: "maxLuxValue")
        aCoder.encodeObject(alsValue, forKey: "alsValue")
        aCoder.encodeObject(diffValue, forKey: "diffValue")
        aCoder.encodeObject(minSlopeValue, forKey: "minSlopeValue")
        aCoder.encodeObject(maxSlopeValue, forKey: "maxSlopeValue")
        aCoder.encodeObject(keyModValue, forKey: "keyModValue")
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as! String
        ruValue = aDecoder.decodeObjectForKey("ruValue") as! Int
        rdValue = aDecoder.decodeObjectForKey("rdValue") as! Int
        delMValue = aDecoder.decodeObjectForKey("delMValue") as! Int
        delSValue = aDecoder.decodeObjectForKey("delSValue") as! Int
        maxDimValue = aDecoder.decodeObjectForKey("maxDimValue") as! Int
        minDimValue = aDecoder.decodeObjectForKey("minDimValue") as! Int
        sensValue = aDecoder.decodeObjectForKey("sensValue") as! Int
        maxLuxValue = aDecoder.decodeObjectForKey("maxLuxValue") as! Int
        alsValue = aDecoder.decodeObjectForKey("alsValue") as! Bool
        diffValue = aDecoder.decodeObjectForKey("diffValue") as! Int
        minSlopeValue = aDecoder.decodeObjectForKey("minSlopeValue") as! Int
        maxSlopeValue = aDecoder.decodeObjectForKey("maxSlopeValue") as! Int
        keyModValue = aDecoder.decodeObjectForKey("keyModValue") as! Int
        
    }

}