//
//  ViewController.swift
//  Memorable Places
//
//  Created by Gerardo Camilo on 23/5/15.
//  Copyright (c) 2015 ___GRCS___. All rights reserved.
//

import UIKit
import MapKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


var manager: CLLocationManager!
var annotationToDisplay: MKPointAnnotation? = nil
var displayList = Dictionary<Int, MKPointAnnotation>();

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting up the location manager
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest

        
        if annotationToDisplay == nil {
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
        }
        else {
            map.addAnnotation(annotationToDisplay!)
            // Setting map area' limits
            let latDelta:CLLocationDegrees = 0.01
            let lonDelta:CLLocationDegrees = 0.01
            
            let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            
            let region:MKCoordinateRegion = MKCoordinateRegionMake(annotationToDisplay!.coordinate, span)
            
            map.setRegion(region, animated: true)
        }
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.addFavoritePlace(_:)))
        uilpgr.minimumPressDuration = 1.0
        map.addGestureRecognizer(uilpgr)
        
    }
    
    /*
    *
    * The function will be called every time user's location is updated.
    * We are going to keep the map centered where the user is located.
    */
    func locationManager( _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        // When locations are updated, at least one location is provided.
        let location: CLLocation = locations[0] 

        // Setting map area' limits
        let latDelta:CLLocationDegrees = 0.01
        let lonDelta:CLLocationDegrees = 0.01
        
        //creating the "square" that will be applied to the region
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        
        //This is the object that defines the area that the map will display
        //Basically, the map will be centered in this area
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location.coordinate, span)
        
        map.setRegion(region, animated: true)
        manager.stopUpdatingLocation()
    
    }

    func addFavoritePlace(_ gestureRecognizer: UILongPressGestureRecognizer){
    
        //Making sure of only using the first action triggered by the long press
        //This way, duplicate places are avoided.
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            
            //Getting the exact point where the user pressed
            let touchPoint = gestureRecognizer.location(in: self.map)
            
            //Extracting the coordinate to set it up in the annotation
            let newCoordinate: CLLocationCoordinate2D = map.convert(touchPoint, toCoordinateFrom: self.map)
            
            //CLLocation needed to get the address using reverseGeocodeLocation
            let location:CLLocation = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            //The annotation title for the annotations will be the address if available
            var address = ""
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            
                if error != nil {
                    print("Reverse geocoder failed with error" + error!.localizedDescription)
                    return
                }
                
                if placemarks?.count > 0 {
                    let pm = placemarks![0] 
                    //println("\(pm.thoroughfare), \(pm.subLocality), \(pm.locality), \(pm.administrativeArea)")
                    
                    var subThoroughfare = ""
                    var thoroughfare = ""
                    var locality = ""
                    
                    if (pm.subThoroughfare != nil ){
                        subThoroughfare = pm.subThoroughfare!
                    }
                    
                    if (pm.thoroughfare != nil ){
                        thoroughfare = pm.thoroughfare!
                    }
                    
                    if (pm.locality != nil ){
                        locality = pm.locality!
                    }
                    
                    address = "\(subThoroughfare) \(thoroughfare) \(locality)"

                    //Annotation to be stored
                    let annotation = MKPointAnnotation();
                    annotation.title = address //"Location \(favoritePlaces.count + 1)";
                    annotation.subtitle = "Added by you";
                    annotation.coordinate = newCoordinate;
                    
                    self.map.addAnnotation(annotation);
                    
                    //Storing annotation, it'll be used by table view controller
                    favoritePlaces[favoritePlaces.count] = annotation
                    
                    //println(address)
                }
                else {
                    print("Problem with the data received from geocoder")
                }
            })

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Cleaning map's annotation before leaving the controller..
        //annotationToDisplay = nil
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {

        if parent == nil {
            //Also saving battery by turning location use off when it isn't required.
            manager.stopUpdatingLocation()

            //Cleaning map's annotation before leaving the controller.
            annotationToDisplay = nil
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

