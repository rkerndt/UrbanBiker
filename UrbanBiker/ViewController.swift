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

class ViewController: UIViewController {

    
    
// This part is to set the switch begin and stop button.
// There is a begin_stop_state which 0 for begin button and 1 for stop button

    var begin_stop_state = 0
    
    @IBOutlet var bb:UIButton!
    @IBAction func begin_stop(_ sender: Any) {
        
        if begin_stop_state == 0{
            begin_stop_state = 1
            bb.setImage(UIImage(named: "stop_red.png"), for: .normal)
        }
        else{
            begin_stop_state = 0
            bb.setImage(UIImage(named: "run.png"), for: .normal)
        }
        print(begin_stop_state)
    }
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GMSServices.provideAPIKey("AIzaSyAxw61PISZuIsvoTogOGGymnQeH5qC8kh0")
        GMSPlacesClient.provideAPIKey("AIzaSyAxw61PISZuIsvoTogOGGymnQeH5qC8kh0")
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 5.5)
        let mapView = GMSMapView.map(withFrame: CGRect(x: 100, y: 100, width: 300, height: 300), camera: camera)
        mapView.center = self.view.center
        
        self.view.addSubview(mapView)

        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        
        
        
    }

 
   

        // Do any additional setup after loading the view, typically from a nib.


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

