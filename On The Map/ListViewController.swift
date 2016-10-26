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
        
        let parsedStudents = ParseClient.sharedInstance().studentInformations
        
        if parsedStudents.count < 1 {
            performUIUpdatesOnMain {
                self.getUdacityStudents()
            }
            getUdacityStudents()
        } else {
            performUIUpdatesOnMain {
                self.udacityStudents = parsedStudents
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshButton.isEnabled = true
    }
    
    // MARK: Actions
    @IBAction func refresh(sender: AnyObject) {
        refreshButton.isEnabled = false
        performUIUpdatesOnMain {
            self.getUdacityStudents()
        }
    }
    
    @IBAction func addOrOverwriteStudent(sender: AnyObject?) {
        if studentAlreadyPosted() {
            let alert = UIAlertController(title: nil, message: "You Have Already Posted a Student Location. Would You Like to Overwrite?", preferredStyle: .alert)
            let overwriteAction = UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.default) {
                UIAlertAction in
                self.presentFindLocationVC(isBeingOverwritten: true)
            }
            alert.addAction(overwriteAction)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            presentFindLocationVC(isBeingOverwritten: false)
        }
    }
    
}
// MARK: - Helpers

extension ListViewController {
    // present FindLocationVC
    func presentFindLocationVC(isBeingOverwritten: Bool) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "findLocationVC") as! FindLocationViewController
        controller.isBeingOverwritten = isBeingOverwritten
        self.present(controller, animated: true, completion: nil)
    }
}

// MARK: - Table view data source

extension ListViewController {

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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Open student's mediaURL when user selects
        let toOpen = udacityStudents[indexPath.row].mediaURL
        if let url = URL(string: toOpen) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

// MARK: Helper methods

extension ListViewController {

    func getUdacityStudents() {
        // start animating activity indicator
        ActivityIndicatorView.startAnimatingActivityIndicator(activityView: self.activityView, controller: self, style: .gray)
        ParseClient.sharedInstance().getMultipleStudentLocations() {
            (success, error) in
            
            // stop animating activity indicator
            ActivityIndicatorView.stopAnimatingActivityIndicator(activityView: self.activityView, controller: self)
            
            // enable the refresh button again
            self.refreshButton.isEnabled = true
            
            if success {
                performUIUpdatesOnMain {
                    let parsedStudents = ParseClient.sharedInstance().studentInformations
                    self.udacityStudents = parsedStudents
                    self.tableView.reloadData()
                }
            } else {
                print("Could not get udacity students!")
            }
        }
    }
    
    // check to see if user already posted a Student Location
    func studentAlreadyPosted() -> Bool {
        var studentInfoAlreadyExists: Bool = false
        for student in ParseClient.sharedInstance().studentInformations {
            if student.uniqueKey == UdacityClient.sharedInstance().accountID {
                studentInfoAlreadyExists = true
                ParseClient.sharedInstance().currentStudentObjectID = student.objectID
                break
            }
        }
        return studentInfoAlreadyExists
    }
}
