//
//  configurarion.swift
//  IRRemote_V6
//
//  Created by Yuchao Chen on 5/2/16.
//  Copyright © 2016 Yuchao Chen. All rights reserved.
//

import Foundation

class Configuration{
    
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