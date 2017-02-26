//
//  ViewController.swift
//  Memorable Places
//
//  Created by Gerardo Camilo on 23/5/15.
//  Copyright (c) 2015 ___GRCS___. All rights reserved.
//

import UIKit
import MapKit

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
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: "addFavoritePlace:")
        uilpgr.minimumPressDuration = 1.0
        map.addGestureRecognizer(uilpgr)
        
    }
    
    /*
    *
    * The function will be called every time user's location is updated.
    * We are going to keep the map centered where the user is located.
    */
    optional func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        // When locations are updated, at least one location is provided.
        var location: CLLocation = locations[0] as! CLLocation

        // Setting map area' limits
        var latDelta:CLLocationDegrees = 0.01
        var lonDelta:CLLocationDegrees = 0.01
        
        //creating the "square" that will be applied to the region
        var span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        
        //This is the object that defines the area that the map will display
        //Basically, the map will be centered in this area
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location.coordinate, span)
        
        map.setRegion(region, animated: true)
        manager.stopUpdatingLocation()
    
    }

    func addFavoritePlace(gestureRecognizer: UILongPressGestureRecognizer){
    
        //Making sure of only using the first action triggered by the long press
        //This way, duplicate places are avoided.
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            
            //Getting the exact point where the user pressed
            var touchPoint = gestureRecognizer.locationInView(self.map)
            
            //Extracting the coordinate to set it up in the annotation
            var newCoordinate: CLLocationCoordinate2D = map.convertPoint(touchPoint, toCoordinateFromView: self.map)
            
            //CLLocation needed to get the address using reverseGeocodeLocation
            var location:CLLocation = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            //The annotation title for the annotations will be the address if available
            var address = ""
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            
                if error != nil {
                    print("Reverse geocoder failed with error" + error!.localizedDescription)
                    return
                }
                
                if placemarks?.count > 0 {
                    let pm = placemarks![0] as! CLPlacemark
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
                    var annotation = MKPointAnnotation();
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Cleaning map's annotation before leaving the controller..
        //annotationToDisplay = nil
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {

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

