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