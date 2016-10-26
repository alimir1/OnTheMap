//
//  ShareLinkViewController.swift
//  On The Map
//
//  Created by Abidi on 10/26/16.
//  Copyright © 2016 com.AliMir. All rights reserved.
//

import UIKit
import MapKit

class ShareLinkViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var enterLinkTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var coordinate: CLLocationCoordinate2D!
    var mapString: String!
    var defaultTextFieldText = "Enter a Link to Share Here"
    var isBeingOverwritten: Bool!
    var successfullyPosted: Bool = false
    
    override func viewDidLoad() {
        submitButton.isEnabled = false
        submitButton.alpha = 0.5
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        zoomToFitMapAnnotations(coordinateToZoom: coordinate)
    }
}

// MARK: - Map View

extension ShareLinkViewController {
    // mapView zoom settings
    func zoomToFitMapAnnotations(coordinateToZoom: CLLocationCoordinate2D) {
        let viewRegion = MKCoordinateRegionMakeWithDistance(coordinateToZoom, 200, 200)
        self.mapView.setRegion(viewRegion, animated: false)

    }
    
    // MARK: - Actions
    
    @IBAction func submitSharedLink(sender: AnyObject? = nil) {
        // POST a Student Location
        
        let udacitySharedInstance = UdacityClient.sharedInstance()
        let parseSharedInstance = ParseClient.sharedInstance()
        let student = StudentInformation(objectID: nil, uniqueKey: udacitySharedInstance.accountID!, firstName: (udacitySharedInstance.udacityUser?.firstName)!, lastName: (udacitySharedInstance.udacityUser?.lastName)!, mapString: self.mapString, latitude: self.coordinate.latitude, longitude: self.coordinate.longitude, mediaURL: self.enterLinkTextField.text!)
        
        parseSharedInstance.postStudentLocation(isBeingOverwritten: isBeingOverwritten, student: student) { (success, objectID, error) in
            if success {
                print("Successfully posted!")
                self.successfullyPosted = true
                self.performSegue(withIdentifier: "unwindToMapsVC", sender: self)
            } else {
                print("Could not post user info! Error: \(error?.localizedDescription)")
            }
        }
        
    }
    
    func tap(gesture: UITapGestureRecognizer) {
        enterLinkTextField.resignFirstResponder()
    }
}


// MARK: - UITextFieldDelegate

extension ShareLinkViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if enterLinkTextField.text == defaultTextFieldText {
            enterLinkTextField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if enterLinkTextField.text != "" {
            textField.resignFirstResponder()
            submitSharedLink()
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if enterLinkTextField.text == "" {
            enterLinkTextField.text = defaultTextFieldText
        } else {
            submitButton.isEnabled = true
            submitButton.alpha = 1.0
        }
    }
    
}




