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
import MapKit



//global data

var Data : DataPakage = DataPakage()
var MODE = Mode()
var sigList: [SignalLight] = []
var sigFrontMeList:[SignalLight] = []
var The_one_signal_light:SignalLight = SignalLight.init(triger1: 100, triger2: 60, signal_light_center: CLLocation(latitude: 44.045491, longitude: -123.071537), degree_to_north: 0.0, readytriger: 200, Signal_light_name: "front_dechets", changable: false)
var state = 0
var Step_count : Double = 0.0
var readyState = 0



class ViewController: UIViewController, GMSMapViewDelegate,CLLocationManagerDelegate {
   
    var locationManager = CLLocationManager()
    
    // This part is to set the switch begin and stop button.
    // There is a begin_stop_state which 0 for begin button and 1 for stop button
    var begin_stop_state = 0
    //end
    
    
    var Vector :Double = 0.0
    var Difference :Double = 0.0
    var motionManager = CMMotionManager()
    


    //This part is to set the signal light center and add any other positions there:
    
    let America = CLLocation(latitude: 37.703026, longitude: -121.759735)
    let alder = CLLocation(latitude: 44.040017, longitude: -123.080197)
    let front_dechets = CLLocation(latitude: 44.045491, longitude: -123.071537)
    let deschutes_2 = CLLocation(latitude: 44.045483, longitude:  -123.073221)
    let deschutes_3 = CLLocation(latitude: 44.045497, longitude:  -123.075030)
    let centennial_pioneer = CLLocation(latitude: 44.056664, longitude: -123.023882)
    
    var S_front_dechets : SignalLight = SignalLight.init(triger1: 100, triger2: 60, signal_light_center: CLLocation(latitude: 44.045491, longitude: -123.071537), degree_to_north: 0.0, readytriger: 200, Signal_light_name: "deschutes",changable: true)
    var S_front_dechets_2 : SignalLight = SignalLight.init(triger1: 100, triger2: 60, signal_light_center: CLLocation(latitude: 44.045483, longitude:  -123.073221), degree_to_north: 0.0, readytriger: 200, Signal_light_name: "deschutes_2",changable: true)
    var S_front_dechets_3 : SignalLight = SignalLight.init(triger1: 100, triger2: 60, signal_light_center: CLLocation(latitude: 44.045497, longitude:  -123.075030), degree_to_north: 0.0, readytriger: 200, Signal_light_name: "deschutes_3",changable: true)
    var S_alder : SignalLight = SignalLight.init(triger1: 100, triger2: 60, signal_light_center: CLLocation(latitude: 44.040017, longitude: -123.080197), degree_to_north: 0.0, readytriger: 200, Signal_light_name: "alder",changable: true)
    var S_America : SignalLight = SignalLight.init(triger1: 100, triger2: 60, signal_light_center: CLLocation(latitude: 37.703026, longitude: -121.759735), degree_to_north: 0.0, readytriger: 200, Signal_light_name: "America",changable: true)
    
    var S_static_siglight : SignalLight = SignalLight.init(triger1: 100, triger2: 60, signal_light_center: CLLocation(latitude: 44.045490, longitude: -123.069765), degree_to_north: 0.0, readytriger: 200, Signal_light_name: "static_siglight", changable: true)
    
    var S_centennial_pioneer : SignalLight = SignalLight.init(triger1:290, triger2: 90, signal_light_center: CLLocation(latitude: 44.056709, longitude: -123.024077), degree_to_north: 0.0, readytriger: 300, Signal_light_name: "centennial_pioneer", changable: true)
    
       //end
    

    //This part is to create some variables which will be used in later's functions. No needs to change this part.
    
   
    var The_Direction_to_change_light_for = ""
    
    
   
    //20 7.5  //50.0 28.0 80.0
    var triger1vaule = 50.0
    var triger2value = 20.0
    var trigerreadyvaule = 80.0
   
    //end
    
    
    
    
    
    
    @IBOutlet weak var Mapview: GMSMapView!
    
    
    @IBOutlet var course: UILabel!
    
   
    
    
    @IBOutlet var Mode_Change_Button: UIButton!
    @IBAction func Mode_Change(_ sender: UIButton) {
        
        
        if MODE.get_mode_number() == 0.0{
            MODE.change_mode()
            Mode_Change_Button.setImage(UIImage(named: "walk.png"), for: .normal)
            self.course.text = MODE.get_mode_name()
            
        }
        else{
            MODE.change_mode()
            Mode_Change_Button.setImage(UIImage(named: "bike.png"), for: .normal)
            self.course.text = MODE.get_mode_name()

        }
 
    }
  
    
    @IBOutlet var bb:UIButton!
    @IBAction func begin_stop(_ sender: Any) {
        
        if begin_stop_state == 0{
            begin_stop_state = 1
            bb.setImage(UIImage(named: "stop_red.png"), for: .normal)
            Mapview.isHidden = false
            //self.locationManager.startUpdatingHeading()
            self.locationManager.startUpdatingLocation()
            
            
            if MODE.get_mode_name() == "Walking Mode"{
                for i in sigList{
                i.revise_TrigerOne(new: 0.5 * triger1vaule)
                i.revise_Triger2(new: 0.5 * triger2value)
                i.revise_ReadyTriger(new: 0.5 * trigerreadyvaule)
                Mapview.clear()
                setupData()
              }
            }
            else if MODE.get_mode_name() == "Bicycle Mode"{
                for i in sigList {
                i.revise_TrigerOne(new: triger1vaule)
                i.revise_Triger2(new: triger2value)
                i.revise_ReadyTriger(new: trigerreadyvaule)
                Mapview.clear()
                setupData()
            }
            }
            
        }
        else{
            begin_stop_state = 0
            bb.setImage(UIImage(named: "GGO.jpg"), for: .normal)
            Mapview.isHidden = true
            self.locationManager.stopUpdatingLocation()
            //self.locationManager.stopUpdatingHeading()
        }
        print(begin_stop_state)
    }
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sigList = [S_alder,S_America,S_front_dechets,S_front_dechets_2,S_front_dechets_3, S_centennial_pioneer]
        Mapview_setup()
        setupData()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: { didAllow, error in
            
            
        })
        
         //Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(greenWaive), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: 120.0, target: self, selector: #selector(updateGPS), userInfo: nil, repeats: true)
       // var map: MKMapView
        
        
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        auth_check()
        
        motionManager.accelerometerUpdateInterval = 0.5
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!){
            (data,error) in
            if let myData = data
            {
                //print("\(String(describing: data?.acceleration.x)) \(String(describing: data?.acceleration.y)) \(String(describing: data?.acceleration.z))")
                //print(myData)
                self.Vector = sqrt((myData.acceleration.x)*(myData.acceleration.x) + (myData.acceleration.y) * (myData.acceleration.y) + (myData.acceleration.z) * (myData.acceleration.z) )
                self.Difference = abs(self.Vector-1)
                print("diff is  \(String(self.Difference))")
                if self.Difference>0.3{
                    Step_count += 1
                    //print(" steps is \(String(self.Step_count))")
                    self.course.text = String(Step_count)

                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "info"), object: nil)
            }
        }

    }
    
    var dirction = ""
    var course_direction = ""
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let location = locations.last
        
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom:18)
        Mapview.animate(to: camera)
        
        updateDataPakage(location: location!)
        The_one_signal_light = check_closest_signal_light()
        state_check()
        readytriggerCHeck()
        
        let Background_state = UIApplication.shared.applicationState
        
        if Background_state == .background {
            print("background")
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        }
        else if Background_state == .active {
           
            // foreground
        }
        
        
        
        
        //print("\(location?.course) and  \(getBearingBetweenTwoPoints1(point1: location!,  point2: The_one_signal_light.get_Signal_light_center()))")
//        Data.revise_course(newCourse: 270.0)
//        Data.revise_speed(newspeed: 5.0)
        
        if Data.get_course() != -1{
            sigFrontMeList = []
            
            if Data.get_course() < 45.0 && Data.get_course() >= 315.0{
                course_direction = "up"
            }
            else if Data.get_course() >= 45.0 && Data.get_course() <= 135.0{
                course_direction = "right"
            }
            else if Data.get_course() > 135.0 && Data.get_course() <= 225.0{
                course_direction = "down"
            }
            else if Data.get_course() > 225.0 && Data.get_course() < 315.0{
                course_direction = "left" 
            }
            
            for i in sigList{
                if checkDirection(point_1: i.get_Signal_light_center(), point_2: location!) == course_direction{
                    
                    if course_direction == "up"{
                        
                        if i.get_Signal_light_center().coordinate.latitude > Data.get_coordnate().latitude && i.get_Signal_light_center().coordinate.latitude < Data.get_coordnate().latitude + 0.005 && i.get_Signal_light_center().coordinate.longitude > Data.get_coordnate().longitude - 0.0003 && i.get_Signal_light_center().coordinate.longitude < Data.get_coordnate().longitude + 0.0003{
                            
                            sigFrontMeList.append(i)
                        }
                    }
                    else if course_direction == "down"{
                        if i.get_Signal_light_center().coordinate.latitude > Data.get_coordnate().latitude - 0.005 && i.get_Signal_light_center().coordinate.latitude < Data.get_coordnate().latitude && i.get_Signal_light_center().coordinate.longitude > Data.get_coordnate().longitude - 0.0003 && i.get_Signal_light_center().coordinate.longitude < Data.get_coordnate().longitude + 0.0003{
                            
                            sigFrontMeList.append(i)
                        }
                    }
                    else if course_direction == "left"{
                         if i.get_Signal_light_center().coordinate.latitude > Data.get_coordnate().latitude - 0.0003 && i.get_Signal_light_center().coordinate.latitude < Data.get_coordnate().latitude + 0.0003 && i.get_Signal_light_center().coordinate.longitude > Data.get_coordnate().longitude - 0.005 && i.get_Signal_light_center().coordinate.longitude < Data.get_coordnate().longitude {
                            
                            sigFrontMeList.append(i)
                        }
                    }
                    else if course_direction == "right"{
                          if i.get_Signal_light_center().coordinate.latitude > Data.get_coordnate().latitude - 0.0003 && i.get_Signal_light_center().coordinate.latitude < Data.get_coordnate().latitude + 0.0003 && i.get_Signal_light_center().coordinate.longitude > Data.get_coordnate().longitude && i.get_Signal_light_center().coordinate.longitude < Data.get_coordnate().longitude + 0.005{
                            
                            sigFrontMeList.append(i)
                        }
                        
                    }
    
                }
            }
            
        }
        else {
            sigFrontMeList = []
        }
        
        
        
        
        
        
        
        
        
        ////print("current signal light is \(The_one_signal_light.get_sig_name())")
        course.text = The_one_signal_light.get_sig_name()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "info"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "info2"), object: nil)

        //Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: false)
        //self.locationManager.stopUpdatingLocation()
        //        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
        //            self.locationManager.startUpdatingLocation()
        //            print(
        //                "Begin"
        //
        //            )
        //        })
        //StopDirection_check()
        //print(getBearingBetweenTwoPoints1(point1 : signal_light_center, point2 : location!))

        
    }

    
    func checkDirection(point_1 : CLLocation, point_2 : CLLocation) -> String{
        let degree_diff = getBearingBetweenTwoPoints1(point1: point_1,  point2: point_2)
        
        if degree_diff > -45 && degree_diff < 45{
            
            return "left"
            
            
        }
        else if degree_diff > -135 && degree_diff < -45{
            return "down"
            
            
        }
            
        else if degree_diff > 45 && degree_diff < 135{
            return "up"
            
        }
        else{
            
            return "right"
        }

    }
   
    
    
    
    func readytriggerCHeck(){
        
        if Data.get_distance() < trigerreadyvaule{
            readyState = 1
        }
        if Data.get_distance() >= trigerreadyvaule{
            readyState = 0
        }

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    
    
    
    
    
    
    
    
    //Packages:
    var c = 0.0
    var c2 = 0.0
    var c3 = 0.0
    
    func move_from_where(str: String){
        
        let center = The_one_signal_light.get_Signal_light_center()
        let most_left = center.coordinate.longitude - 0.001
        let most_right = center.coordinate.longitude + 0.001
        let most_up = center.coordinate.latitude + 0.001
        let most_down = center.coordinate.latitude - 0.001
        
        let green_last = 8.0
        let red_last = 15.0
        let step = 0.0001 * 0.3
        
        let left = CLLocationCoordinate2D(latitude: center.coordinate.latitude,longitude:most_left)
        let right = CLLocationCoordinate2D(latitude: center.coordinate.latitude,longitude:most_right)
        
        
        
        

        c2 = The_one_signal_light.current_time
        
        if str == "left"{
        var head = center.coordinate.longitude - red_last * step + c2 * step
        var rear = head - (green_last * step)
        
        //for left
        if head > center.coordinate.longitude{
            head = center.coordinate.longitude
        }
        if rear < most_left{
            rear = most_left
        }
        if rear > center.coordinate.longitude{
            rear = center.coordinate.longitude
        }
        
        let path = GMSMutablePath()
        path.add(CLLocationCoordinate2D(latitude: left.latitude, longitude: head))
        path.add(CLLocationCoordinate2D(latitude: left.latitude, longitude: rear))
        let polyline = GMSPolyline(path: path)
        polyline.map = Mapview
        polyline.strokeWidth = 30.0
        polyline.strokeColor = .green
        
        
        
        }
        
        else if str == "right"{
        var head2 = center.coordinate.longitude + red_last * step - c2 * step
        var rear2 = head2 + (green_last * step)
        
        //for right
        if head2 < center.coordinate.longitude{
            head2 = center.coordinate.longitude
        }
        if rear2 > most_right{
            rear2 = most_right
        }
        if rear2 < center.coordinate.longitude{
            rear2 = center.coordinate.longitude
        }

        
       
        
       
        
        let path2 = GMSMutablePath()
        path2.add(CLLocationCoordinate2D(latitude: left.latitude, longitude: head2))
        path2.add(CLLocationCoordinate2D(latitude: left.latitude, longitude: rear2))
        let polyline2 = GMSPolyline(path: path2)
        polyline2.map = Mapview
        polyline2.strokeWidth = 30.0
        polyline2.strokeColor = .green
        
        }
        
        else if str == "up"{
            var head2 = center.coordinate.latitude + red_last * step - c2 * step
            var rear2 = head2 + (green_last * step)
            
            //for right
            if head2 < center.coordinate.latitude{
                head2 = center.coordinate.latitude
            }
            if rear2 > most_up{
                rear2 = most_up
            }
            if rear2 < center.coordinate.latitude{
                rear2 = center.coordinate.latitude
            }
            
            
            
            
            
            
            let path2 = GMSMutablePath()
            path2.add(CLLocationCoordinate2D(latitude: head2, longitude: center.coordinate.longitude))
            path2.add(CLLocationCoordinate2D(latitude: rear2, longitude: center.coordinate.longitude))
            let polyline2 = GMSPolyline(path: path2)
            polyline2.map = Mapview
            polyline2.strokeWidth = 30.0
            polyline2.strokeColor = .green
            
        }

        
        else if str == "down"{
            var head2 = center.coordinate.latitude - red_last * step + c2 * step
            var rear2 = head2 - (green_last * step)
            
            //for right
            if head2 > center.coordinate.latitude{
                head2 = center.coordinate.latitude
            }
            if rear2 < most_down{
                rear2 = most_down
            }
            if rear2 > center.coordinate.latitude{
                rear2 = center.coordinate.latitude
            }
    
            let path2 = GMSMutablePath()
            path2.add(CLLocationCoordinate2D(latitude: head2, longitude: center.coordinate.longitude))
            path2.add(CLLocationCoordinate2D(latitude: rear2, longitude: center.coordinate.longitude))
            let polyline2 = GMSPolyline(path: path2)
            polyline2.map = Mapview
            polyline2.strokeWidth = 30.0
            polyline2.strokeColor = .green
            
        }


       
    }
    
    
   
    func greenWaive() {
        
        
        Mapview.clear()
        
        setupData()
        if dirction != ""{
            
        move_from_where(str: dirction)
       
            
            
            }
                
    }
    

    func updateGPS() {
        
        sendGPSJSON()
        
        print("start!!")
        
    }
  
    
    func check_closest_signal_light() -> SignalLight{
        
        var result = The_one_signal_light
        var value_to_compare = Double.infinity
        
        var changable_list:[SignalLight] = []
        for i in sigList{
            if i.get_changable() == true{
                changable_list.append(i)
            }
            
            
        }
        for i in changable_list{
            let d = i.get_Signal_light_center().distance(from: CLLocation(latitude: Data.get_coordnate().latitude,longitude: Data.get_coordnate().longitude))
            if  d < value_to_compare{
                value_to_compare = d
                result = i
            }
        }
        
        return result
        
    }

    
    func updateDataPakage(location:CLLocation){
        
        let a = location.course
        Data.revise_course(newCourse: Double(a))
        
        
        let c = location.coordinate
        Data.revise_coordnate(newCoordnate: c)
        
        
        let lat = location.distance(from: The_one_signal_light.get_Signal_light_center())
        Data.revise_distance(newDistance: Double(lat))
        
        let s = Double(location.speed)
        Data.revise_speed(newspeed: s)
        
        Data.revise_location(newlocation: location)
        
    }

    
    func auth_check(){
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
    

    //var count = 0.0
    func state_check(){
        //count = count + 1
        //print(" count is \(count)")
        if state == 0{
            if Data.get_distance() < The_one_signal_light.get_TrigerOne(){
                LetsVibrate()
                notification_jump_out(title: "Trigger 1", subtitle: "TRIGGERED", body: "you have touched trigger 1")
                sendJSON(to: "on")
                state = 1
                print("1111111")
    
            }
        }
        else if state != 0 {
            if Data.get_distance() > The_one_signal_light.get_TrigerOne(){
                state = 0
                LetsVibrate()
                notification_jump_out(title: "Trigger 0", subtitle: "TRIGGERED", body: "you have touched trigger 0")
                print("000000")
            }
            else if Data.get_distance() < The_one_signal_light.get_TrigerTwo(){
                if Data.get_triger_count() == 0{
                    state = 1
                    //triger_count += 1
                    Data.revise_triger_count(newtriger_count: Data.get_triger_count() + 1)
                    
                }
            }
            else if Data.get_distance() > The_one_signal_light.get_TrigerTwo() &&  Data.get_triger_count() == 1{
                state = 2
                Data.revise_triger_count(newtriger_count: 0.0)
                LetsVibrate()
                notification_jump_out(title: "Trigger 2", subtitle: "TRIGGERED", body: "you have touched trigger 2")
                sendJSON(to: "off")
                print("222222")
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

    
    func setupData() {
        
        for i in sigList{
            
            
            let TrigerOneCenter = CLLocationCoordinate2D(latitude: i.get_Signal_light_center().coordinate.latitude, longitude: i.get_Signal_light_center().coordinate.longitude)
            let TrigerOne = GMSCircle(position: TrigerOneCenter, radius: i.get_TrigerOne())
            TrigerOne.fillColor = UIColor(red: 0, green: 1.5, blue: 0, alpha: 0.05)
            TrigerOne.strokeColor = UIColor(red: 0.46, green: 0.76, blue: 0.20, alpha: 1.0)
            TrigerOne.strokeWidth = 4
            TrigerOne.map = Mapview
            
            
            let TrigerTwoCenter = CLLocationCoordinate2D(latitude: i.get_Signal_light_center().coordinate.latitude, longitude: i.get_Signal_light_center().coordinate.longitude)
            let TrigerTwo = GMSCircle(position: TrigerTwoCenter, radius: i.get_TrigerTwo())
            TrigerTwo.fillColor = UIColor(red: 1.5, green: 0, blue: 0, alpha: 0.05)
            TrigerTwo.strokeColor = UIColor(red: 0.88, green: 0.05, blue: 0.05, alpha: 1.0)
            TrigerTwo.strokeWidth = 4
            TrigerTwo.map = Mapview
            
//            let TrigerRCenter = CLLocationCoordinate2D(latitude: i.get_Signal_light_center().coordinate.latitude, longitude: i.get_Signal_light_center().coordinate.longitude)
//            let TrigerR = GMSCircle(position: TrigerRCenter, radius: i.get_ReadyTriger())
//            TrigerR.fillColor = UIColor(red: 0, green: 0, blue: 1.5, alpha: 0.05)
//            TrigerR.strokeColor = UIColor(red: 0.3, green: 0.05, blue: 0.55, alpha: 1.0)
//            TrigerR.strokeWidth = 4
//            TrigerR.map = Mapview
            
        }
        
        
        
    }
    
    func notification_jump_out(title: String, subtitle: String, body: String){
        let content = UNMutableNotificationContent()
        //let content = UNNotificationContent()
        content.sound = UNNotificationSound.default()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1 , repeats: false)
        let request = UNNotificationRequest(identifier:"time Done", content: content, trigger : trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }

    func showAlert(_ title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func sendJSON(to: String) {
       
        let Direct = Data.get_course()
        let Lon = Data.get_coordnate().longitude
        let Lat = Data.get_coordnate().latitude
        var Mod = MODE.get_mode_name()
        let Sig = The_one_signal_light.get_sig_name()
        var Email = ""
        if UserDefaults.standard.string(forKey: "userEmail") != nil{
            Email = UserDefaults.standard.string(forKey: "userEmail")!
        }
        if Mod == "Bicycle Mode"{
            Mod = "bike"
        }
        else{
            Mod = "Walking Mode"
        }

        
        let dict = ["trigger": to, "direction":Direct, "longtitude": Lon, "latitude": Lat, "mode": Mod, "signal_light_name": Sig, "email": Email] as [String: Any]

        if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) {
            
            
            let url = NSURL(string: "http://ks.fastraq.bike/phase")!
            
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
                if error != nil{
                    //print(error?.localizedDescription)
                    return
                }
                
                do {
                    let json =  try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                    
                    
                    if let parseJSON = json {
                        
                        print(parseJSON)
                    }
                }
            }
            task.resume()
        }

    }
    
    
    func sendGPSJSON() {
        
        let Direct = Data.get_course()
        let Lon = Data.get_coordnate().longitude
        let Lat = Data.get_coordnate().latitude
        var Mod = MODE.get_mode_name()
        let Sig = The_one_signal_light.get_sig_name()
        var Email = ""
        if UserDefaults.standard.string(forKey: "userEmail") != nil{
            Email = UserDefaults.standard.string(forKey: "userEmail")!
        }
        
        if Mod == "Bicycle Mode"{
            Mod = "bike"
        }
        else{
            Mod = "Walking Mode"
        }
        
        
        
        let dict = [ "direction":Direct, "longtitude": Lon, "latitude": Lat, "mode": Mod, "signal_light_name": Sig, "email": Email] as [String: Any]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) {
            
            
            let url = NSURL(string: "http://ks.fastraq.bike/log_gps")!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
                if error != nil{
                    //print(error?.localizedDescription)
                    return
                }
                
                do {
                    let json =  try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                    
                    
                    if let parseJSON = json {
                        
                        print(parseJSON)
                    }
                }
            }
            task.resume()
        }
        
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
        //self.locationManager.startUpdatingHeading()
        //self.locationManager.startUpdatingLocation()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.allowsBackgroundLocationUpdates = true
    }
    
    
    //    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)
    //    {
    //
    //        //print(newHeading.magneticHeading)
    //
    //    }
}



