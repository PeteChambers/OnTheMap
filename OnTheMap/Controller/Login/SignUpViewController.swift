//
//  SignUpViewController.swift
//  OnTheMap
//
//  Created by Pete Chambers on 14/03/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation
import WebKit

class SignUpViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let url = URL(string: "https://auth.udacity.com/sign-up")
        let request = URLRequest(url: url!)
        webView.load(request)
        activityIndicator.stopAnimating()
    }
    
}

