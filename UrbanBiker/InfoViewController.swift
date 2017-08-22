//
//  InfoViewController.swift
//  UrbanBiker
//
//  Created by Ziming Guo on 6/30/17.
//  Copyright © 2017 zimingg. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import AudioToolbox.AudioServices
import UserNotifications
import CoreMotion
import MapKit





class InfoViewController: UIViewController {
    
    @IBOutlet var mode_label: UILabel!
    

    @IBOutlet var location_label: UILabel!
  
    @IBOutlet var siglight_label: UILabel!
   
    @IBOutlet var direction_label: UILabel!
    
    @IBOutlet var state_label: UILabel!
    
    @IBOutlet var steps_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("dukjwedhfoweuihfowihfe")
        print(Data)
        NotificationCenter.default.addObserver(self, selector: #selector(print_Info), name: NSNotification.Name(rawValue: "info"), object: nil)
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    
    func print_Info(){
        //print("Got it!")
        
        mode_label.text = MODE.get_mode_name()
        location_label.text = "(\(Data.get_coordnate().latitude), \(Data.get_coordnate().longitude))"
        siglight_label.text = The_one_signal_light.get_sig_name()
        direction_label.text = "\(Data.get_course())"
        state_label.text = "\(state)"
        steps_label.text = "\(Step_count)"
        
    }
}
