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
        
        var queue = [String]()
        
        queue.append(processDetailCommand(Configuration.settingTypes.rampUP.value, value: settings.ruValue))
        queue.append(processDetailCommand(Configuration.settingTypes.rampDown.value, value: settings.rdValue))
        
        if settings.delMValue >= 4{
            queue.append(processDetailCommand(Configuration.settingTypes.delayToOffM.value, value: settings.delMValue))
        }else{
            queue.append(processDetailCommand(Configuration.settingTypes.delayToOffS.value, value: settings.delMValue * 60 + settings.delSValue))
        }
        
        queue.append(processDetailCommand(Configuration.settingTypes.sensitivity.value, value: settings.sensValue))
        
        if settings.alsValue == true{
            queue.append(processDetailCommand(Configuration.settingTypes.maxLuxValue.value, value: settings.maxLuxValue))
        }
        
        return queue
        
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
    
    func delay(time: Double, closure: () -> () ){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_MSEC))),
                       dispatch_get_main_queue(),
                       closure)
    }
}