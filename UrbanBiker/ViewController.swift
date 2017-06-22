//
//  ViewController.swift
//  UrbanBiker
//
//  Created by zimingg on 6/20/17.
//  Copyright © 2017 zimingg. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class ViewController: UIViewController, GMSMapViewDelegate,CLLocationManagerDelegate {
   
 
    
// This part is to set the switch begin and stop button.
// There is a begin_stop_state which 0 for begin button and 1 for stop button

    var begin_stop_state = 0
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var Mapview: GMSMapView!
    
    
    @IBOutlet var course: UILabel!
  
    
    @IBOutlet var bb:UIButton!
    @IBAction func begin_stop(_ sender: Any) {
        
        if begin_stop_state == 0{
            begin_stop_state = 1
            bb.setImage(UIImage(named: "stop_red.png"), for: .normal)
            Mapview.isHidden = false
            self.locationManager.startUpdatingHeading()
            self.locationManager.startUpdatingLocation()
        }
        else{
            begin_stop_state = 0
            bb.setImage(UIImage(named: "run.png"), for: .normal)
            Mapview.isHidden = true
            self.locationManager.stopUpdatingLocation()
            self.locationManager.stopUpdatingHeading()
        }
        print(begin_stop_state)
    }
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Mapview_setup()
        Mapview.isMyLocationEnabled = true
        
        print("Now")
        //print(Mapview.myLocation)
        Mapview.delegate = self
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        
        self.locationManager.startUpdatingHeading()
        self.locationManager.startUpdatingLocation()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.allowsBackgroundLocationUpdates = true
        

        
    }
    
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
       
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom:100)
        Mapview.animate(to: camera)
        
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        //self.locationManager.stopUpdatingLocation()
        
        
        //print(location?.coordinate)
        
        //course.text = String(describing: location?.course)
        print(location?.course)
        course.text = String( describing: location?.course)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)
    {
       
        print(newHeading.magneticHeading)
       
    }
    
    
   

        // Do any additional setup after loading the view, typically from a nib.


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    //Packages:
    
    func Mapview_setup(){
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 48.857165, longitude: 2.354613, zoom: 50.0)
        Mapview.camera = camera
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                Mapview.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("The style definition could not be loaded: \(error)")
        }
        
        Mapview.isHidden = true
        
    }

}




