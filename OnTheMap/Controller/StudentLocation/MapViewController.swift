//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Pete Chambers on 25/01/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var addLocationButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    // MARK: - Properties
    var studentLocations = arrayOfStudentLocations
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        }
    
    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        
        UdacityClient.sharedInstance().taskForDELETEingASession() { (success, errotString) in
            
            guard (success == true) else {
                performUIUpdatesOnMain {
                    self.createAlert(title: "Error", message: "Failure to logout.")
                }
                return
            }
            performUIUpdatesOnMain {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
       
        ParseClient.sharedInstance().getStudentLocations() { (success, errorString) in
    
            guard (success == true) else {
                performUIUpdatesOnMain {
                    self.createAlert(title: "Error", message: "Failure to download student locations data. The Internet connection appears to be offline.")
                }
                return
            }
        }
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateMapView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func updateMapView() {
        performUIUpdatesOnMain {self.addStudentAnnotations()}
    }
    
    func addStudentAnnotations() {
        var annotations = [MKPointAnnotation]()
        
        for student in studentLocations {
            
            let lat = student.latitude
            let long = student.longitude
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
        
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
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!)
                
            }
        }
    }
}





