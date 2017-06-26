//
//  DataPakage.swift
//  UrbanBiker
//
//  Created by Ziming Guo on 6/26/17.
//  Copyright © 2017 zimingg. All rights reserved.
//

import Foundation
import CoreLocation

class DataPakage {
   
    private var Course = 0.0
    private var Coordnate = CLLocationCoordinate2D(latitude: 0.0,longitude: 0.0)
    private var Distance = 0.0
    
    func revise_course(newCourse: Double){
        self.Course = newCourse
    }
    
    func revise_coordnate(newCoordnate: CLLocationCoordinate2D){
        self.Coordnate = newCoordnate
    }
    
    func revise_distance(newDistance: Double){
        self.Distance = newDistance
    }
   
    func get_course()->Double{
        
        return self.Course
    }
    
    func get_coordnate()->CLLocationCoordinate2D{
        return self.Coordnate
    }
    func get_distance()->Double{
        return self.Distance
    }
}
