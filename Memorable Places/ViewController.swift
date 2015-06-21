//
//  ViewController.swift
//  Memorable Places
//
//  Created by Gerardo Camilo on 23/5/15.
//  Copyright (c) 2015 ___GRCS___. All rights reserved.
//

import UIKit
import MapKit

var annotationToDisplay: MKPointAnnotation? = MKPointAnnotation()
var displayList = Dictionary<Int, MKPointAnnotation>();

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var uilpgr = UILongPressGestureRecognizer(target: self, action: "addFavoritePlace:")
        uilpgr.minimumPressDuration = 1
        map.addGestureRecognizer(uilpgr)
        
        if annotationToDisplay != nil
        {
            map.addAnnotation(annotationToDisplay!)
        }
        
        
    }

    func addFavoritePlace(gestureRecognizer: UILongPressGestureRecognizer){
    
        var touchPoint = gestureRecognizer.locationInView(self.map)
        var newCoordinate: CLLocationCoordinate2D = map.convertPoint(touchPoint, toCoordinateFromView: self.map)
        
        
        var annotation = MKPointAnnotation();
        annotation.title = "Location \(favoritePlaces.count + 1)";
        annotation.subtitle = "Added by you";
        annotation.coordinate = newCoordinate;
        
        map.addAnnotation(annotation);
        favoritePlaces[favoritePlaces.count] = annotation

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        annotationToDisplay = nil
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        
        if parent == nil {
         annotationToDisplay = nil
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

