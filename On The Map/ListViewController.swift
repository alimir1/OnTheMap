//
//  ListViewController.swift
//  On The Map
//
//  Created by Ali Mir on 10/22/16.
//  Copyright © 2016 com.AliMir. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    var udacityStudents = [StudentInformation]()
    let activityView = UIActivityIndicatorView()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUdacityStudents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshButton.isEnabled = true
    }
    
    // MARK: Actions
    @IBAction func refresh(sender: AnyObject) {
        refreshButton.isEnabled = false
        getUdacityStudents()
    }
    
}

extension ListViewController {
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return udacityStudents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "udacityStudentCell", for: indexPath)
        let udacityStudent = udacityStudents[indexPath.row]
        
        cell.textLabel?.text = "\(udacityStudent.firstName) \(udacityStudent.lastName)"
        cell.detailTextLabel?.text = udacityStudent.mediaURL
        
        return cell
    }
}

// MARK: Helper methods

extension ListViewController {

    func getUdacityStudents() {
        // start animating activity indicator
        ActivityIndicatorView.startAnimatingActivityIndicator(activityView: self.activityView, controller: self, style: .gray)
        ParseClient.sharedInstance().getMultipleStudentLocations() {
            (success, error) in
            if success {
                let parsedStudents = ParseClient.sharedInstance().studentInformations
                performUIUpdatesOnMain {
                    self.udacityStudents = parsedStudents
                    self.tableView.reloadData()
                }
            } else {
                print("Could not get udacity students!")
            }
            
            // stop animating activity indicator
            ActivityIndicatorView.stopAnimatingActivityIndicator(activityView: self.activityView, controller: self)
            
            // enable the refresh button again
            self.refreshButton.isEnabled = true
        }
    }
}
