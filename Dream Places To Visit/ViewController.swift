//
//  ViewController.swift
//  Dream Places To Visit
//
//  Created by Adhita Selvaraj on 24/03/16.
//  Copyright (c) 2016 DreamCatcher. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var map: MKMapView!
    
    var locationManager = CLLocationManager()
    
    var newCoordinates = CLLocationCoordinate2D()
    
    var title1 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
        
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
       // println(locations)
        
        var userLocation:CLLocation = locations[0] as! CLLocation
        var latitude = userLocation.coordinate.latitude
        var longitude = userLocation.coordinate.longitude
        var latDelta:CLLocationDegrees = 0.05
        var lonDelta:CLLocationDegrees = 0.05
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        self.map.setRegion(region, animated: true)
        
        var uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        uilpgr.minimumPressDuration = 1.0
        self.map.addGestureRecognizer(uilpgr)
        
    }
    
    
    func action(gestureRecognizer: UIGestureRecognizer)
    {
        
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            
            var touchPoint = gestureRecognizer.locationInView(self.map)
            
            newCoordinates = self.map.convertPoint(touchPoint, toCoordinateFromView: self.map)
            
            var location = CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude)
                
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                
                
                if (error == nil) {
                    
                    if let p = CLPlacemark(placemark: placemarks?[0] as! CLPlacemark){
                        
                        var subthoroughfare:String = ""
                        var thoroughfare:String = ""
                        
                        if p.subThoroughfare != nil {
                            subthoroughfare = p.subThoroughfare
                        }
                        
                        if p.thoroughfare != nil {
                            thoroughfare = p.thoroughfare
                        }
                        
                        self.title1 = "\(subthoroughfare) \(thoroughfare)"
                        
                    }
                    
                }
               
                if self.title1 == ""
                {
                
                self.title1 = "Added on \(NSDate())"
                    
                }
                
                var annotation = MKPointAnnotation()
                annotation.coordinate = self.newCoordinates
                annotation.title = self.title1
                self.map.addAnnotation(annotation)
                
            })
     
            places.append(["name":self.title1,"lat":"\(newCoordinates.latitude)","lon":"\(newCoordinates.longitude)"])
            
            
           }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

