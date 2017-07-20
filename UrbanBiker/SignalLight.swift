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
    var r = 100.0
    
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
    }
    func revise_circle(){
        if r-10 >= 0{
            r = r-10
            
        }
        else{
            r = 100
        }
        self.circle = GMSCircle(position: CLLocationCoordinate2D(latitude: Signal_light_center.coordinate.latitude, longitude: Signal_light_center.coordinate.longitude), radius: CLLocationDistance(r))
        self.circle.fillColor = UIColor(red: 1, green: 1.5, blue: 0, alpha: 0.05)
        self.circle.strokeColor = UIColor(red: 0.15, green: 0.45 , blue: 0.71, alpha: 0.7)
        self.circle.strokeWidth = 20
        

        
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
