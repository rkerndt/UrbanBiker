//
//  GreenwaveViewController.swift
//  UrbanBiker
//
//  Created by Ziming Guo on 7/25/17.
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






class GreenwaveViewController: UIViewController {
    

    @IBOutlet var siginfo: UILabel!
    
    @IBOutlet var table: UIImageView!
    
    @IBOutlet var light: UIImageView!
    @IBOutlet var speed: UILabel!
    @IBOutlet var unit: UIButton!
  
    @IBOutlet var first_background: UIImageView!
    
    @IBOutlet var first_picture: UIImageView!
    @IBOutlet var first_label: UILabel!
    
    @IBOutlet var circle_v: UIView!
    
    var unit_state = 0
    @IBAction func unit_change(_ sender: UIButton){
        
        if unit_state == 0{
            
            unit_state = 1
            unit.setTitle("miles/h", for: .normal)
        }
        else if unit_state == 1{
            unit_state = 0
            unit.setTitle("m/s", for: .normal)
        }
        
        
    }
    
    var circle = CircleView()
    var button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        circle = CircleView(frame: CGRect(x: self.view.frame.size.width*0.42, y: self.view.frame.size.width*0.45, width: 50, height: 50))
        circle.backgroundColor = UIColor.clear
        view.addSubview(circle)

        let button = UIButton(frame: CGRect(x: 20, y: 150, width: 80, height: 40))
        button.setTitle("Animate", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.setTitleColor(UIColor.blue.withAlphaComponent(0.3), for: .highlighted)
        button.addTarget(self, action: #selector(GreenwaveViewController.addCircleView), for: .touchUpInside)
        view.addSubview(button)
        
        
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(update_Info), name: NSNotification.Name(rawValue: "info2"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateSiglight), name: NSNotification.Name(rawValue: "siglightUpdate"), object: nil)
        
        
       
        
    }
    func animateCircle() {
        circle.resizeCircleWithPulseAinmation(300, duration: 4)
        
    }
    
    func addCircleView() {
        let diceRoll = CGFloat(Int(arc4random_uniform(7))*50)
        var circleWidth = CGFloat(200)
        var circleHeight = circleWidth
        
        // Create a new CircleView
        var c = CircleView(frame: CGRect(x: diceRoll, y: 0, width: circleWidth, height: circleHeight))
        
        view.addSubview(circle)
        
        // Animate the drawing of the circle over the course of 1 second
        circle.animateCircle(duration: 1.0)
    }
    
    
    
    
       
    func updateSiglight(){
        
        
        
        if sigFrontMeList.count >= 1{
            //first_label.text = "\(sigFrontMeList[0].current_state)  \(sigFrontMeList[0].current_time)"
           
           
            
            if (sigFrontMeList[0].current_time >= (sigFrontMeList[0].red_interval + sigFrontMeList[0].green_interval - 1) && sigFrontMeList[0].current_time <= (sigFrontMeList[0].red_interval + sigFrontMeList[0].green_interval) ){
                light.backgroundColor = .yellow
                first_label.text = "\(sigFrontMeList[0].red_interval + sigFrontMeList[0].green_interval - sigFrontMeList[0].current_time)"
                
            }
            else if sigFrontMeList[0].current_time > sigFrontMeList[0].red_interval{
                light.backgroundColor = .green
                first_label.text = "\(sigFrontMeList[0].green_interval - (sigFrontMeList[0].current_time - sigFrontMeList[0].red_interval))"
                
            }
            else{
                light.backgroundColor = .red
                first_label.text = "\(sigFrontMeList[0].red_interval - sigFrontMeList[0].current_time)"
            }
        }
        
       
        else{
            first_label.text = ""
            light.backgroundColor = nil
            first_background.image = nil
            
        }

        
        
        
    }
    
    func update_Info(){
        
        
        //speed
        if Data.get_speed() != -1{
            
            if unit_state == 0{
                //speed.text = String(Double(Data.get_speed()))
                speed.text = String(Double(round(1000 * Data.get_speed())/1000))
                
            }
            else if unit_state == 1{
                speed.text = String(Data.get_speed() * 3600 / 1000 / 1.6)
                speed.text = String(Double(round(1000 * Data.get_speed() * 3600 / 1000 / 1.6)/1000))
            }
        }
        else{
            speed.text = "detecting..."
        }
        
        sigFrontMeList.sort{ (one, two) ->Bool in
            
            return (one.get_Signal_light_center().distance(from: Data.get_location())) < (two.get_Signal_light_center().distance(from: Data.get_location()))
            
        }
        //siglight1.text  = "None"
        //siglight2.text = "None"
        
        if sigFrontMeList.count > 0{
        siginfo.text = "\(sigFrontMeList.count) lights front of you, now in \(sigFrontMeList[0].get_sig_name()) "
        
        }
        else{
            siginfo.text = ""
        }
        
        if Data.get_speed() != -1{
            print("sigFrontMeList.count = \(sigFrontMeList.count)" )
            print(sigFrontMeList.description)
            if sigFrontMeList.count == 1{
                //sig_light_name.text = sigFrontMeList[0].get_sig_name()
                update1(number: 0)
                
           
            }
                
            else if sigFrontMeList.count > 1{
               // sig_light_name.text = "First: \(sigFrontMeList[0].get_sig_name()) Next: \(sigFrontMeList[1].get_sig_name())"
                update1(number: 0)
                //update1(number: 1)
                
            }
        
        
        }

    }
    
        
    
    func update1(number : Int){
        //siglight1.text = "\(sigFrontMeList[0].current_state)  \(sigFrontMeList[0].current_time)"
        var distance = Data.get_location().distance(from: sigFrontMeList[number].get_Signal_light_center())
        if distance - 36 <= 0{
            distance = 0.001
        }
        else{
            distance = distance - 36
        }
        
        
        let time_needed = distance / Data.get_speed()
       

        var label_number = sigFrontMeList[number].current_time + time_needed
        let remainder = label_number.truncatingRemainder(dividingBy: (sigFrontMeList[number].green_interval + sigFrontMeList[number].red_interval))
        if remainder > sigFrontMeList[number].red_interval {
            
            //green
            if number == 0{
                
                //first_background.backgroundColor = UIColor(red: 0.60, green: 0.80, blue: 0.44, alpha: 1.0) //green
                first_background.image = UIImage(named: "g")
               
                label_number = sigFrontMeList[number].green_interval - (remainder - sigFrontMeList[number].red_interval)
                //first_label.text = String(label_number.rounded())
            }
            
        }
            
            
        else if remainder <= sigFrontMeList[number].red_interval{
            
            let diffierence = sigFrontMeList[number].red_interval - remainder
            
            if diffierence >= 0.7 * sigFrontMeList[number].red_interval{
                
                if number == 0{
                    //first_background.backgroundColor = UIColor(red: 0.71, green: 0.33, blue: 0.41, alpha: 1.0)  //red
                    
                    
                    label_number = sigFrontMeList[number].red_interval - diffierence
                   // first_label.text = String(label_number.rounded())
                }
                
               
                
                
            }
            else if diffierence <= 0.3 * sigFrontMeList[0].red_interval{
                
                
                if number == 0{
                    //first_background.backgroundColor = UIColor(red: 0.71, green: 0.33, blue: 0.41, alpha: 1.0)  //red
                    
                   
                    label_number = diffierence
                   // first_label.text = String(label_number.rounded())
                }
                
 
            }
                
                
            else if diffierence < 0.7 * sigFrontMeList[0].red_interval && diffierence > 0.3 * sigFrontMeList[0].red_interval{
                
                if number == 0{
                    //first_background.backgroundColor = UIColor(red: 0.71, green: 0.33, blue: 0.41, alpha: 1.0)
                    
                    
                    //first_label.text = "NO!"

                }
               
     
            }
            
        }

    }
    
    
    //if sigFrontMeList.count > 1{
    //siglight2.text = "\(sigFrontMeList[1].current_state)  \(sigFrontMeList[1].current_time)"
    //sig_light_name.text = "First: \(sigFrontMeList[0].get_sig_name()) Next: \(sigFrontMeList[1].get_sig_name())"


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

}

}
