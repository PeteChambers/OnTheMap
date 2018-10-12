//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Pete Chambers on 14/03/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddLocationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var enterLocationTextField: UITextField!
    @IBOutlet weak var EnterUrlTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Properties
    
    var newLocation = ""
    var newURL = ""
    var newLatitude = 0.0
    var newLongitude = 0.0
    var coordinates: CLLocationCoordinate2D?
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        enterLocationTextField.delegate = self
        EnterUrlTextField.delegate = self
        
    }
    
    
    @IBAction func findLocationButtonTapped(_ sender: Any) {
        guard let location = enterLocationTextField.text, location != "" else {
            print("Location is empty")
            createAlert(title: "Error", message: "Please enter your location")
            return
        }
        guard let url = EnterUrlTextField.text, url != "", url.hasPrefix("https://") else {
            print("URL is empty")
            createAlert(title: "Error", message: "Invalid URL. Please enter a URL that starts with 'https://'")
            return
        }
        let geoCode = CLGeocoder()
        
        activityIndicator.startAnimating()
       
        
        geoCode.geocodeAddressString(location) { (placemarks, error) in
            
            print("getCordinatesFromLocation error \(String(describing: error))")
            
            guard (error == nil) else {
                
                self.createAlert(title: "Error", message: "Could not calculate coordinates. Check your Internet connection.")
                self.activityIndicator.isHidden = true
                return
            }
            
            let placemark = placemarks?.first
            
            guard let placemarkLatitude = placemark?.location?.coordinate.latitude else {
                self.createAlert(title: "Error", message: "Could not calculate latitude coordinate. Re-try location.")
                 self.activityIndicator.isHidden = true
                return
            }
            
            UserLocation.NewUserLocation.latitude = placemarkLatitude
            
            guard let placemarkLongitude = placemark?.location?.coordinate.longitude else {
                self.createAlert(title: "Error", message: "Could not calculate longitude coordinate. Re-try location.")
                
                self.activityIndicator.stopAnimating()

                return
            }
            
            UserLocation.NewUserLocation.longitude = placemarkLongitude
                self.passDataToNextViewController()
        }
    }
    
    func passDataToNextViewController() {
        
        performUIUpdatesOnMain {

            let submitLocationVC = self.storyboard?.instantiateViewController(withIdentifier: "SubmitLocationViewController") as! SubmitLocationViewController
            
            self.navigationController?.pushViewController(submitLocationVC, animated: true)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        enterLocationTextField.text = ""
        EnterUrlTextField.text = ""
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
