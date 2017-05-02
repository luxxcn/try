//
//  ViewController.swift
//  MapMe
//
//  Created by 星 鲁 on 2017/5/2.
//  Copyright © 2017年 xxing. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var manager:CLLocationManager?
    var geocoder:CLGeocoder?
    var placemark:CLPlacemark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.mapView.mapType = .standard
        //self.mapView.mapType = .satellite
        //self.mapView.mapType = .hybrid
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - (Private) Instance Methods
    func openCallout(_ annotation: MKAnnotation?) {
        
        self.progressBar.progress = 1.0
        self.progressLabel.text = "Showing Annotation"
        self.mapView.selectAnnotation(annotation!, animated: true)
    }
    
    func reverseGeocode(location: CLLocation) {
        
        if geocoder == nil {
            geocoder = CLGeocoder()
        }
        
        geocoder?.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            
            if error != nil {
                
                let alertController = UIAlertController(title: "Error translating coordinates into location", message: "Geocoder did not recognize coordinates", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(action)
                self.show(alertController, sender: nil)
            } else if (placemarks?.count)! > 0 {
                
                self.placemark = placemarks?[0]
                
                self.progressBar.progress = 0.5
                self.progressLabel.text = "Location Determined"
                
                let annotaion = MapLocation()
                annotaion.street = self.placemark?.thoroughfare
                annotaion.city = self.placemark?.locality
                annotaion.state = self.placemark?.administrativeArea
                annotaion.zip = self.placemark?.postalCode
                annotaion.coordinate = location.coordinate
                
                self.mapView.addAnnotation(annotaion)
            }
        })
    }

    @IBAction func findMe(_ sender: Any) {
        
        if manager == nil {
            manager = CLLocationManager()
        }
        
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.startUpdatingLocation()
        
        self.progressBar.isHidden = false
        self.progressBar.progress = 0.0
        self.progressLabel.text = "Determining Current Location"
        self.button.isHidden = true
    }
    
    // MARK - CLLocationManagerDelegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let newLocation = locations[locations.count - 1]
        if newLocation.timestamp.timeIntervalSince1970 < Date().timeIntervalSince1970 - 60 {
            
            return
        }
        
        let viewRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 2000, 2000)
        let adjustRegion = self.mapView.regionThatFits(viewRegion)
        self.mapView.setRegion(adjustRegion, animated: true)
        
        manager.delegate = nil
        manager.stopUpdatingLocation()
        
        self.progressBar.progress = 0.25
        self.progressLabel.text = "Reverse Gencoding Location"
        
        self.reverseGeocode(location: newLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        let alert = UIAlertController(title: "Error getting Location", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.show(alert, sender: nil)
    }
    
    // MARK - MKMapViewDelegate Methods
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let placemarkIdentifier = "Map Location identifier"
        
        if annotation is MapLocation {
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: placemarkIdentifier)
            
            if annotationView == nil {
                
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: placemarkIdentifier)
            } else {
                
                annotationView?.annotation = annotation
            }
            
            annotationView?.isEnabled = true
            //annotationView.animateDrop = true
            //MKPinAnnotationView.purplePinColor()
            annotationView?.canShowCallout = true
            self.perform(#selector(openCallout(_:)), with: annotation, afterDelay: 0.5)
            
            self.progressBar.progress = 0.75
            self.progressLabel.text = "Creating Annotation"
            
            return annotationView
        }
        return nil
    }
    
    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        
        let alert = UIAlertController(title: "Error loading map", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.show(alert, sender: nil)
    }

}

