//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Pete Chambers on 28/02/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    var keyboardOnScreen = false
    
    // MARK: Outlets
    
    @IBOutlet weak var udacityLogoImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        emailTextField.delegate = self
        passwordTextField.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
        
    }
        
    // MARK: Login
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let username = emailTextField.text, username != "" else {
            print("email is empty")
            self.createAlert(title: "Error", message: "Please enter your email address")
            return
        }
        guard let password = passwordTextField.text, password != "" else {
            print("password is empty")
            self.createAlert(title: "Error", message: "Please enter your password")
            return
        }
    
        UdacityClient.sharedInstance().authenticateUser(username: username, password: password) { (success, errorString) in
            
            guard success else {
                
                performUIUpdatesOnMain {
                    self.createAlert(title: "Error", message: errorString)
                   
                }
                return
            }
    
            print("Successfully authenicated the Udacity user.")
            
            // Call getPublicUserData
            UdacityClient.sharedInstance().gettingPublicUserData() { (success, errorString) in
                guard success else {
                    print("Unsuccessful in obtaining firstName and lastName from Udacity Public User Data: \(errorString)")
                    
                    performUIUpdatesOnMain {
                        self.createAlert(title: "Error", message: "Could not obtain first and last name from Udacity Public User Data")
                    }
                    return
                }
                print("Successfully obtained first and last name from Udacity Public User Data")
                
                // Call getAStudentLocation
                ParseClient.sharedInstance().getAStudentLocation() { (success, errorString) in
                    guard (success == true) else {
                        print("Unsuccessful in obtaining A Student Location from Parse: \(errorString)")
                        
                        performUIUpdatesOnMain {
                            self.createAlert(title: "Error", message: "Unable to obtain Student Location data.")
                        }
                        return
                    }
                    
                    // Call getStudentLocations
                    ParseClient.sharedInstance().getStudentLocations() { (success, errorString) in
                        
                        guard (success == true) else {
                            // display the errorString using createAlert
                            // The app gracefully handles a failure to download student locations.
                            print("Unsuccessful in obtaining Student Locations from Parse: \(errorString)")
                            
                            performUIUpdatesOnMain {
                                self.createAlert(title: "Error", message: "Failure to download student locations data.")
                            }
                            return
                        }
                        print("Successfully obtained Student Locations data from Parse")
                        self.completeLogin()
                        
                    }
                }
            }
        }
    }

    @IBAction func signupButtonPressed(_ sender: UIButton) {
    }
    
    func showAlert(title:String, message:String?) {
        
        if let message = message {
            let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func completeLogin() {
        performUIUpdatesOnMain {
            self.debugTextLabel.text = ""
            self.setUIEnabled(true)
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "TabBarViewController") as! UITabBarController
            self.present(controller, animated: true, completion: nil)
            }
    }
}

    
    // MARK: - LoginViewController: UITextFieldDelegate
    
    extension LoginViewController {
        
        func setUIEnabled(_ enabled: Bool) {
            emailTextField.isEnabled = enabled
            passwordTextField.isEnabled = enabled
            loginButton.isEnabled = enabled
            debugTextLabel.text = ""
            debugTextLabel.isEnabled = enabled
            
            // adjust login button alpha
            if enabled {
                loginButton.alpha = 1.0
            } else {
                loginButton.alpha = 0.5
            }
        }

        @objc func keyboardWillShow(_ notification:Notification) {
            if passwordTextField.isFirstResponder || emailTextField.isFirstResponder == true {
                view.frame.origin.y = 0 - (getKeyboardHeight(notification)/2.5)
            }
        }
        
        func getKeyboardHeight(_ notification:Notification) -> CGFloat {
            
            let userInfo = notification.userInfo
            let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
            return keyboardSize.cgRectValue.height
        }
        
        func subscribeToKeyboardNotifications() {
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            
        }
        
        func unsubscribeFromKeyboardNotifications() {
            
            NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
            NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        }
        
        @objc func keyboardWillHide(_ notification:Notification) {
            if passwordTextField.isFirstResponder || emailTextField.isFirstResponder == true {
                view.frame.origin.y = 0
            }
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
        }
    }

