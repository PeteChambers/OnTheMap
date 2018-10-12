//
//  ViewExtension.swift
//  OnTheMap
//
//  Created by Pete Chambers on 15/03/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension UIViewController {
    
    // MARK: Alert Views
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: URL Can Open
    func verifyUrl (urlString: String?) -> Bool {
        
        let app = UIApplication.shared
        
        if let urlString = urlString {
            if let url  = NSURL(string: urlString) {
                return app.canOpenURL(url as URL)
            }
        }
        return false
    }

}
