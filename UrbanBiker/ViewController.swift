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
import AudioToolbox.AudioServices
import UserNotifications
import CoreMotion


class ViewController: UIViewController, GMSMapViewDelegate,CLLocationManagerDelegate {
   
    var locationManager = CLLocationManager()
    
    // This part is to set the switch begin and stop button.
    // There is a begin_stop_state which 0 for begin button and 1 for stop button
    var begin_stop_state = 0
    //end
    

    //This part is to set the signal light center and add any other positions there
    //var signal_light_center = CLLocation(latitude: 44.045489, longitude: -123.071530)
    let America = CLLocation(latitude: 37.703026, longitude: -121.759735)
    let alder = CLLocation(latitude: 44.040017, longitude: -123.080197)
    let front_dechets = CLLocation(latitude: 44.045491, longitude: -123.071537)

    //end
    
    
    
    
    
    //This part is to set the triger1 and triger2 and then the map will draw tow circles according to those parameters.
    //let triger1 = 500.0
    //let triger2 = 300.5
    //end
    

    //This part is to create some variables which will be used in later's functions. No needs to change this part.
    var state = 0
    var triger_count = 0
//    var DataPakage_Course = 0.0
//    var DataPakage_coordnate = CLLocationCoordinate2D(latitude: 0.0,longitude: 0.0)
//    var DataPakage_Distance = 0.0
    var The_Direction_to_change_light_for = ""
    
    
    var Data : DataPakage = DataPakage()
    
    var Signal_Light : SignalLight = SignalLight.init(triger1: 20.0, triger2: 7.5, signal_light_center: CLLocation(latitude: 44.045491, longitude: -123.071537), degree_to_north: 0.0, readytriger: 50.0)
    //end
    
    
    var v :Double = 0.0
    var d :Double = 0.0
    var s_count : Double = 0.0
    var motionManager = CMMotionManager()

    
    
    
    
    @IBOutlet weak var Mapview: GMSMapView!
    
    
    @IBOutlet var course: UILabel!
  
    
    @IBOutlet var bb:UIButton!
    @IBAction func begin_stop(_ sender: Any) {
        
        if begin_stop_state == 0{
            begin_stop_state = 1
            bb.setImage(UIImage(named: "stop_red.png"), for: .normal)
            Mapview.isHidden = false
            //self.locationManager.startUpdatingHeading()
            self.locationManager.startUpdatingLocation()
        }
        else{
            begin_stop_state = 0
            bb.setImage(UIImage(named: "run.png"), for: .normal)
            Mapview.isHidden = true
            self.locationManager.stopUpdatingLocation()
            //self.locationManager.stopUpdatingHeading()
        }
        print(begin_stop_state)
    }
    
   
    func presentAlert() {
        let alertController = UIAlertController(title: "Email?", message: "Please input your email:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                // store your data
                UserDefaults.standard.set(field.text, forKey: "userEmail")
                UserDefaults.standard.synchronize()
            } else {
                // user did not fill field
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Email"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Signal_Light.revise_Signal_light_center(new: alder)
        Mapview_setup()
        setupData()
    }
   
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
            // authorization were denied
        else if CLLocationManager.authorizationStatus() == .denied {
            showAlert("Location services were previously denied. Please enable location services for this app in Settings.")
        }
            // we do have authorization
        else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
        
        
        if UserDefaults.standard.string(forKey: "userEmail") == nil{
            presentAlert()
        }
        
        motionManager.accelerometerUpdateInterval = 0.5
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!){
            (data,error) in
            if let myData = data
            {
                print("\(String(describing: data?.acceleration.x)) \(String(describing: data?.acceleration.y)) \(String(describing: data?.acceleration.z))")
                self.v = sqrt((data?.acceleration.x)!*(data?.acceleration.x)! + (data?.acceleration.y)! * (data?.acceleration.y)! + (data?.acceleration.z)! * (data?.acceleration.z)! )
                self.d = abs(self.v-1)
                print("diff is  \(String(self.d))")
                if self.d>0.3{
                    self.s_count += 1
                    print(" steps is \(String(self.s_count))")
                    self.course.text = String(self.s_count)

                }
            }
            
        }

        
        
        
        
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
    
    func LetsVibrate(){
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
    
    func state_check(){
        if state == 0{
            if Data.get_distance() < Signal_Light.get_TrigerOne(){
                LetsVibrate()
                state = 1
                
                
                
            }
        }
        if state != 0 {
            if Data.get_distance() > Signal_Light.get_TrigerOne(){
                state = 0
            }
            if Data.get_distance() < Signal_Light.get_TrigerTwo(){
                if triger_count == 0{
                    state = 1
                    triger_count += 1
                }
            }
            if Data.get_distance() > Signal_Light.get_TrigerTwo() &&  triger_count == 1{
                state = 2
                triger_count = 0
                LetsVibrate()
            }
        }

    }
    
    func StopDirection_check(){
        
        if Data.get_course() < 45.0 && Data.get_course() > 315.0{
            The_Direction_to_change_light_for = "North"
            
        }
        else if Data.get_course() < 225.0 && Data.get_course() > 135.0{
            The_Direction_to_change_light_for = "South"
            
        }
            
        else if Data.get_course() < 135.0 && Data.get_course() > 45.0{
            The_Direction_to_change_light_for = "West"
            
        }
            
        else if Data.get_course() < 315.0 && Data.get_course() > 225.0{
            The_Direction_to_change_light_for = "East"
        }
        

    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
       
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom:30)
        Mapview.animate(to: camera)
        
        if let a = location?.course{
            
            Data.revise_course(newCourse: Double(a))
        }
        
        //DataPakage_coordnate = (location?.coordinate)!
        
        if let c = location?.coordinate{
            Data.revise_coordnate(newCoordnate: c)
        }
        
        if let lat = location?.distance(from: Signal_Light.get_Signal_light_center()) {
            //DataPakage_Distance =  Double(lat)
            Data.revise_distance(newDistance: Double(lat))
            }
        
        state_check()
        StopDirection_check()
        

        
        
        //print(getBearingBetweenTwoPoints1(point1 : signal_light_center, point2 : location!))
        //print(Data.get_course())
        //print(state)
        //print("\(location?.coordinate.latitude) \(location?.coordinate.longitude) ")
        //print(The_Direction_to_change_light_for)
//        
//        if let a  = UserDefaults.standard.string(forKey: "userEmail"){
//            print(a)
//        }
        
    }

//    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)
//    {
//       
//        //print(newHeading.magneticHeading)
//       
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //Packages:
    
    func setupData() {
        
        
        let TrigerOneCenter = CLLocationCoordinate2D(latitude: Signal_Light.get_Signal_light_center().coordinate.latitude, longitude: Signal_Light.get_Signal_light_center().coordinate.longitude)
        let TrigerOne = GMSCircle(position: TrigerOneCenter, radius: Signal_Light.get_TrigerOne())
        TrigerOne.fillColor = UIColor(red: 0, green: 1.5, blue: 0, alpha: 0.05)
        TrigerOne.strokeColor = UIColor(red: 0.46, green: 0.76, blue: 0.20, alpha: 1.0)
        TrigerOne.strokeWidth = 4
        TrigerOne.map = Mapview
        
        let TrigerTwoCenter = CLLocationCoordinate2D(latitude: Signal_Light.get_Signal_light_center().coordinate.latitude, longitude: Signal_Light.get_Signal_light_center().coordinate.longitude)
        let TrigerTwo = GMSCircle(position: TrigerTwoCenter, radius: Signal_Light.get_TrigerTwo())
        TrigerTwo.fillColor = UIColor(red: 1.5, green: 0, blue: 0, alpha: 0.05)
        TrigerTwo.strokeColor = UIColor(red: 0.88, green: 0.05, blue: 0.05, alpha: 1.0)
        TrigerTwo.strokeWidth = 4
        TrigerTwo.map = Mapview
        
        let TrigerRCenter = CLLocationCoordinate2D(latitude: Signal_Light.get_Signal_light_center().coordinate.latitude, longitude: Signal_Light.get_Signal_light_center().coordinate.longitude)
        let TrigerR = GMSCircle(position: TrigerRCenter, radius: Signal_Light.get_ReadyTriger())
        TrigerR.fillColor = UIColor(red: 0, green: 0, blue: 1.5, alpha: 0.05)
        TrigerR.strokeColor = UIColor(red: 0.3, green: 0.05, blue: 0.55, alpha: 1.0)
        TrigerR.strokeWidth = 4
        TrigerR.map = Mapview
        
    }

    func showAlert(_ title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func Mapview_setup(){
        //let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 0.0, longitude: 0.0, zoom: 1.0)
        //Mapview.camera = camera
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



