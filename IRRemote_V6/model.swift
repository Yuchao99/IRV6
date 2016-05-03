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
    
    //process settings queue
    func processQueue(settings: Configuration) -> [String]{
        
        var results = [String]()
        results.append(decimalToReversedBinary(settings.ruValue))
        results.append(decimalToReversedBinary(settings.rdValue))
        results.append(decimalToReversedBinary(settings.delValue))
        results.append(decimalToReversedBinary(settings.maxDimValue))
        results.append(decimalToReversedBinary(settings.minDimValue))
        results.append(decimalToReversedBinary(settings.sensValue))
        results.append(decimalToReversedBinary(settings.maxLuxValue))
        results.append(decimalToReversedBinary(settings.minLuxValue))
        results.append(decimalToReversedBinary(settings.lensValue))
        results.append(decimalToReversedBinary(settings.alsValue))
        
        return results
    }
    
    //excute setting queue
    func excuteQueue(node: Protocal, settings: [String]){
        
        for setting: String in settings{
            loadingBuffers(node, command: setting)
        }
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