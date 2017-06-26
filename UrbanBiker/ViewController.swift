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
   
    var locationManager = CLLocationManager()
    
    // This part is to set the switch begin and stop button.
    // There is a begin_stop_state which 0 for begin button and 1 for stop button
    var begin_stop_state = 0
    //end
    

    //This part is to set the signal light center and add any other positions there
    var signal_light_center = CLLocation(latitude: 44.045489, longitude: -123.071530)
    let America = CLLocation(latitude: 37.703026, longitude: -121.759735)
    //end
    
    
    
    
    
    //This part is to set the triger1 and triger2 and then the map will draw tow circles according to those parameters.
    let triger1 = 500.0
    let triger2 = 300.0
    //end
    
    //This part is to create some variables which will be used in later's functions. No needs to change this part.
    var state = 0
    var triger_count = 0
    var DataPakage_Course = 0.0
    var DataPakage_coordnate = CLLocationCoordinate2D(latitude: 0.0,longitude: 0.0)
    var DataPakage_Distance = 0.0
    //end
    
    
    
    
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
        signal_light_center = America
        Mapview_setup()
        setupData()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
    
    func getBearingBetweenTwoPoints1(point1 : CLLocation, point2 : CLLocation) -> Double {
        
        let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)
        
        let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        if radiansToDegrees(radians: radiansBearing)-90 < -360 {
            return 360 - (radiansToDegrees(radians: radiansBearing)-90)
        }
        else{
        
            return radiansToDegrees(radians: radiansBearing)-90
        }
    }
    
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
       
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom:15)
        Mapview.animate(to: camera)
        
        //print(float(location?.distance(from: CLLocation(latitude: 37.703026, longitude: -121.759735) )))
        if let a = location?.course{
            DataPakage_Course = Double(a)
        }
        DataPakage_coordnate = (location?.coordinate)!
        if let lat = location?.distance(from: signal_light_center) {
            DataPakage_Distance =  Double(lat)
            }
        if state == 0{
            if DataPakage_Distance < triger1{
                state = 1
            }
        }
        if state != 0 {
            if DataPakage_Distance > triger1{
                state = 0
            }
            if DataPakage_Distance < triger2{
                if triger_count == 0{
                    state = 1
                    triger_count += 1
                }
            }
            if DataPakage_Distance > triger2 &&  triger_count == 1{
                    state = 2
                    triger_count = 0
            }
        }
        //print("\(DataPakage_Course)  \(DataPakage_coordnate)  \(DataPakage_Distance)")
        //print(getBearingBetweenTwoPoints1(point1 : signal_light_center, point2 : location!))
        print(state)
        course.text = String(state)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)
    {
       
        //print(newHeading.magneticHeading)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //Packages:
    
    func setupData() {
        
        
        let TrigerOneCenter = CLLocationCoordinate2D(latitude: signal_light_center.coordinate.latitude, longitude: signal_light_center.coordinate.longitude)
        let TrigerOne = GMSCircle(position: TrigerOneCenter, radius: triger1)
        TrigerOne.fillColor = UIColor(red: 0, green: 1.5, blue: 0, alpha: 0.05)
        TrigerOne.strokeColor = UIColor(red: 0.46, green: 0.76, blue: 0.20, alpha: 1.0)
        TrigerOne.strokeWidth = 4
        TrigerOne.map = Mapview
        
        let TrigerTwoCenter = CLLocationCoordinate2D(latitude: signal_light_center.coordinate.latitude, longitude: signal_light_center.coordinate.longitude)
        let TrigerTwo = GMSCircle(position: TrigerTwoCenter, radius: triger2)
        TrigerTwo.fillColor = UIColor(red: 1.5, green: 0, blue: 0, alpha: 0.05)
        TrigerTwo.strokeColor = UIColor(red: 0.88, green: 0.05, blue: 0.05, alpha: 1.0)
        TrigerTwo.strokeWidth = 4
        TrigerTwo.map = Mapview
        
    }

    
    
    
    func Mapview_setup(){
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 48.857165, longitude: 2.354613, zoom: 10.0)
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
        Mapview.isMyLocationEnabled = true
        
        
        Mapview.delegate = self
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        
        self.locationManager.startUpdatingHeading()
        self.locationManager.startUpdatingLocation()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.allowsBackgroundLocationUpdates = true
    }
}



