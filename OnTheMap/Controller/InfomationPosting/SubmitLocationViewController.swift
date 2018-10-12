//
//  SubmitLocationViewController.swift
//  OnTheMap
//
//  Created by Pete Chambers on 14/03/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class SubmitLocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - Properties

    var newLocation = UserLocation.NewUserLocation.mapString
    var newURL = UserLocation.NewUserLocation.mediaURL
    var newLatitude = UserLocation.NewUserLocation.latitude
    var newLongitude = UserLocation.NewUserLocation.longitude
    var userObjectId = UserLocation.UserData.objectId
    
    var coordinates = [CLLocationCoordinate2D]() {
        didSet {
  
            for (_, coordinate) in self.coordinates.enumerated() {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = newLocation
                annotation.subtitle = newURL
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let location = userNewLocationData()
        var annotations = [MKPointAnnotation]()
        
        for item in location {
            
            let lat = CLLocationDegrees(item["latitude"] as! Double)
            let long = CLLocationDegrees(item["longitude"] as! Double)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let first = item["firstName"] as! String
            let last = item["lastName"] as! String
            let mediaURL = item["mediaURL"] as! String
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            annotations.append(annotation)
        }

        self.mapView.addAnnotations(annotations)
        let initialLocation = CLLocation(latitude: newLatitude, longitude: newLongitude)
        centerMapOnLocation(location: initialLocation)
    }
    
    func userNewLocationData() -> [[String : Any]] {
        return  [
            [
                "createdAt" : "",
                "firstName" : UserLocation.UserData.firstName,
                "lastName" : UserLocation.UserData.lastName,
                "latitude" : UserLocation.NewUserLocation.latitude,
                "longitude" : UserLocation.NewUserLocation.longitude,
                "mapString" : UserLocation.NewUserLocation.mapString,
                "mediaURL" : UserLocation.NewUserLocation.mediaURL,
                "objectId" : "",
                "uniqueKey" : UserLocation.UserData.uniqueKey,
                "updatedAt" : ""
            ]
        ]
    }
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: - MKMapViewDelegate
   
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let url = view.annotation?.subtitle! {
                
                app.open(URL(string:url)!, options: [:], completionHandler: { (success) in
                    if !success {
                        self.createAlert(title: "Invalid URL", message: "Could not open URL")
                    }
                })
            }
        } else {
            createAlert(title: "Error", message: "Could not transition to web browser. Re-try URL. Otherwise, URL may not be valid.")
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        submitButton.isEnabled = false
        if userObjectId.isEmpty {
            callPostToStudentLocation()
            
        } else {
            print("PUT called")
            callPutToStudentLocation()
        }
    }
    
    // MARK: - Methods
    
    func callPostToStudentLocation() {
        ParseClient.sharedInstance().postAStudentLocation(newUserMapString: newLocation, newUserMediaURL: newURL, newUserLatitude: newLatitude, newUserLongitude: newLongitude, completionHandlerForLocationPOST: { (success, errorString) in
            
            guard (success == true) else {
     
                performUIUpdatesOnMain {
                    self.createAlert(title: "Error", message: "Unable to add new location. The Internet connection appears to be offline.")
                }
                return
            }
            
            // Call getAStudentLocation from ParseConvenience
            ParseClient.sharedInstance().getAStudentLocation() { (success, errorString) in
                guard (success == true) else {
                    performUIUpdatesOnMain {
                        self.createAlert(title: "Error", message: "Failure to download user location data.")
                    }
                    return
                }
                ParseClient.sharedInstance().getStudentLocations() { (success, errorString) in
                    
                    guard (success == true) else {
                        performUIUpdatesOnMain {
                            self.createAlert(title: "Error", message: "Failure to download student locations data.")
                        }
                        return
                    }
                    print("Successfully obtained Student Locations data from Parse")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        })
    }
    
    func callPutToStudentLocation() {
        ParseClient.sharedInstance().putAStudentLocation(newUserMapString: newLocation, newUserMediaURL: newURL, newUserLatitude: newLatitude, newUserLongitude: newLongitude, completionHandlerForLocationPUT: { (success, errorString) in
            
            guard (success == true) else {
                performUIUpdatesOnMain {
                    self.createAlert(title: "Error", message: "Unable to add new location. The Internet connection appears to be offline.")
                }
                return
            }
            
            // Call getAStudentLocation from ParseConvenience
            ParseClient.sharedInstance().getAStudentLocation() { (success, errorString) in
                guard (success == true) else {
                    // display the errorString using createAlert
                    performUIUpdatesOnMain {
                        self.createAlert(title: "Error", message: "Failure to download user location data.")
                    }
                    return
                }
                ParseClient.sharedInstance().getStudentLocations() { (success, errorString) in
                    
                    guard (success == true) else {
                        performUIUpdatesOnMain {
                            self.createAlert(title: "Error", message: "Failure to download student locations data.")
                        }
                        return
                    }
                    self.dismiss(animated: true, completion: nil)
                    
                }
            }
        })
    }
    
}

