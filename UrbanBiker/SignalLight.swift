//
//  SignalLight.swift
//  UrbanBiker
//
//  Created by Ziming Guo on 6/26/17.
//  Copyright © 2017 zimingg. All rights reserved.
//

import Foundation
import CoreLocation

class SignalLight {
    
    private var TrigerOne = 0.0
    private var TrigerTwo = 0.0
    private var ReadyTriger = 0.0
    private var Signal_light_center = CLLocation()
    
    private var Degree_to_North = 0.0
    
    
    init(triger1: Double, triger2: Double, signal_light_center:CLLocation, degree_to_north: Double, readytriger: Double) {
        self.TrigerOne = triger1
        self.TrigerTwo = triger2
        self.Signal_light_center = signal_light_center
        self.Degree_to_North = degree_to_north
        self.ReadyTriger = readytriger
    }
    
    func revise_TrigerOne (new: Double){
        self.TrigerOne = new
    }
    func revise_Triger2 (new: Double){
        self.TrigerTwo = new
    }
    func revise_Signal_light_center (new: CLLocation){
        self.Signal_light_center = new
    }
    func revise_Degree_to_North (new: Double){
        self.Degree_to_North = new
    }
    func revise_ReadyTriger (new: Double){
        self.ReadyTriger = new
    }
    func get_TrigerOne()->Double{
        
        return self.TrigerOne
    }
    func get_TrigerTwo()->Double{
        
        return self.TrigerTwo
    }
    func get_Signal_light_center()->CLLocation{
        
        return self.Signal_light_center
    }
    func get_Degree_to_North()->Double{
        
        return self.Degree_to_North
    }

    func get_ReadyTriger()->Double{
            
        return self.ReadyTriger
    }

    
    
       
}
