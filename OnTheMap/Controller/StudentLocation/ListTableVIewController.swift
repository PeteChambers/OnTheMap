//
//  ListTableVIewController.swift
//  OnTheMap
//
//  Created by Pete Chambers on 14/03/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation
import UIKit

class ListTableViewController: UITableViewController {
    
    // MARK: - Properties
    var studentLocations = arrayOfStudentLocations
    
    
    @IBOutlet var listTableView: UITableView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var addLocationButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        refreshTableView()
        
    }
    
    // Refresh Table Data
    func refreshTableView() {
        if let ListTableView = listTableView {
            ListTableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "ListTableViewCell"
        let studentLocation = studentLocations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        let first = studentLocation.firstName as String
        let last = studentLocation.lastName as String
        let mediaURL = studentLocation.mediaURL as String
        cell?.textLabel!.text = "\(first) \(last)"
        cell?.imageView!.image = UIImage(named: "icon_pin")
        cell?.detailTextLabel!.text = mediaURL
        cell?.imageView!.contentMode = UIViewContentMode.scaleAspectFit
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let app = UIApplication.shared
        let url = studentLocations[indexPath.row].mediaURL
        
        if verifyUrl(urlString: url) == true {
            app.open(URL(string:url)!)
        } else {
            performUIUpdatesOnMain {
                self.createAlert(title: "Invalid URL", message: "Could not open URL. URL may be invalid.")
            }
        }
    }
}
