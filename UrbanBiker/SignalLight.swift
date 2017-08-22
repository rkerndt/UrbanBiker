//
//  SignalLight.swift
//  UrbanBiker
//
//  Created by Ziming Guo on 6/26/17.
//  Copyright © 2017 zimingg. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps
import GooglePlaces

class SignalLight {
    
    private var TrigerOne = 0.0
    private var TrigerTwo = 0.0
    private var ReadyTriger = 0.0
    private var Signal_light_center = CLLocation()
    private var Signal_light_name = ""
    private var Changable = false
    
    var current_time = 1.0
    
    let green_interval = 27.0
    let red_interval = 35.0
    var current_state = "red"
    
    
    
   var circle = GMSCircle()
    
    
    private var Degree_to_North = 0.0
    
    
    init(triger1: Double, triger2: Double, signal_light_center:CLLocation, degree_to_north: Double, readytriger: Double,Signal_light_name: String, changable: Bool) {
        self.TrigerOne = triger1
        self.TrigerTwo = triger2
        self.Signal_light_center = signal_light_center
        self.Degree_to_North = degree_to_north
        self.ReadyTriger = readytriger
        self.Signal_light_name = Signal_light_name
        self.Changable = changable
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(Time_Simulator), userInfo: nil, repeats: true)
    }
    
    @objc func Time_Simulator(){
        self.current_time += 1
        if self.current_time > green_interval + red_interval{
            self.current_time = 1
        }
        if self.current_time <= red_interval{
            current_state = "red"
        }
        else if self.current_time > red_interval{
            current_state = "green"
        }
       // print("time is: \(self.current_time)  and now is \(current_state)")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "siglightUpdate"), object: nil)
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "info2"), object: nil)
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
    func revise_sig_name(new:String){
        self.Signal_light_name = new
        
    }
    func revise_changable(new: Bool){
        self.Changable = new
    }
    
    func get_changable()->Bool{
        return self.Changable
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
    func get_sig_name() -> String{
        
        return self.Signal_light_name
    }

    func get_circle() -> GMSCircle{
        
        return self.circle
    }
    
       
}
