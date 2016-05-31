//
//  model.swift
//  IRRemote_V6
//
//  Created by Yuchao Chen on 4/29/16.
//  Copyright © 2016 Yuchao Chen. All rights reserved.
//

import Foundation

class Model {
    
    func test() -> String{
        //this is a test for how to manipulate the buffers
        //send 00000111
        let testy = 8
        let testy2 = 5
        return decimalToReversedBinary(testy2) + decimalToReversedBinary(testy)
    }
    //make it contains 16 digits
    func decimalToReversedBinary(x: Int) -> String{
        var str = String(x, radix: 2)
        
        while str.characters.count < 8 {
            str = "0" + str
        }
        
        return str
    }
    
    func adDecimalToReversedBinary(x: Int) -> String{
        var str = String(x, raix: 2)
        
        while str.characters.count < 16 {
            str = "0" + str
        }
        
        return str
    }
    
    func adBinaryFirstPart(x: String) -> String{
        return x[x.startIndex..<x.startIndex.advancedBy(8)]
    }
    
    func adBinaryLastPart(x: String) -> String{
        return x[x.startIndex.advancedBy(8)..<x.endIndex]
    }
    
    //process settings queue
    func processQueue(settings: Configuration) -> [String]{
        
        var results = [String]()
        results.append(decimalToReversedBinary(settings.ruValue))
        results.append(decimalToReversedBinary(settings.rdValue))
        //todo logic for delay only
        //results.append(decimalToReversedBinary(settings.delValue))
        results.append(decimalToReversedBinary(settings.maxDimValue))
        results.append(decimalToReversedBinary(settings.minDimValue))
        results.append(decimalToReversedBinary(settings.sensValue))
//        results.append(decimalToReversedBinary(settings.lensValue))
        //todo @yuchao logiv for lightsensor only
//        results.append(decimalToReversedBinary(settings.alsValue))
//        results.append(decimalToReversedBinary(settings.maxLuxValue))
//        results.append(decimalToReversedBinary(settings.minLuxValue))
        
        return results
    }
    
    //excute setting queue
    func excuteQueue(node: Protocal, settings: [String]){
        
        for setting: String in settings{
            loadingBuffers(node, command: setting)
        }
    }
    
    func processDetailCommand(command: Int, value: Int) -> String {
        
        let commandStr = decimalToReversedBinary(command) + decimalToReversedBinary(value)
        
        return commandStr
        
    }
    
    func processAdCommand(command: Int, value: Int) -> String{
        let commandStr = decimalToReversedBinary(command) + adBinaryFirstPart(decimalToReversedBinary(value) + decimalToReversedBinary(command) + adBinaryLastPart(decimalToReversedBinary(value)))
        
        return commandStr
    }
    
    func loadingBuffers(node: Protocal, command: String){
        for logic in command.characters{
            if logic == "0"{
                node.scheduleBufferZero()
            }else{
                node.scheduleBufferOne()
            }
        }

    }
}