//
//  MotionMode.swift
//  UrbanBiker
//
//  Created by Ziming Guo on 6/29/17.
//  Copyright © 2017 zimingg. All rights reserved.
//

import Foundation
import CoreLocation

class Mode {
    
    private var Mode_Number = 0.0
    
    
    
    func get_mode_number() -> Double{
        
        return self.Mode_Number
        
    }
    func get_mode_name() -> String{
        
        switch (self.Mode_Number) {
            
        case 0:
            return "Bicycle Mode"
        case 1:
            return "Walking Mode"
        default:
            return "None"
        }
        
    }
    
    func change_mode(){
        
        if Mode_Number == 1{
            Mode_Number = 0
        }
        else{
            Mode_Number = 1
        }
    }
    
    
    
    
    
    
    
}
