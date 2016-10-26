//
//  MapViewController.swift
//  On The Map
//
//  Created by Ali Mir on 10/22/16.
//  Copyright © 2016 com.AliMir. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController{
    
    // MARK: - Properties
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    var udacityStudents = [StudentInformation]()
    let activityView = UIActivityIndicatorView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let parsedStudents = ParseClient.sharedInstance().studentInformations
        
        if parsedStudents.count < 1 {
            performUIUpdatesOnMain {
                self.fetchUserInformations()
            }
        } else {
            performUIUpdatesOnMain {
                self.udacityStudents = parsedStudents
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func refreshMap(sender: AnyObject?) {
        performUIUpdatesOnMain {
            self.fetchUserInformations()
        }
    }
    
    @IBAction func logoutFromUdacity(sender: AnyObject?) {
        
        // start animating activity indicator
        ActivityIndicatorView.startAnimatingActivityIndicator(activityView: self.activityView, controller: self, style: .whiteLarge)
        
        UdacityClient.sharedInstance().deleteUdacitySession() { (success, result, error) in
            
            // stop animating activity indicator
            ActivityIndicatorView.stopAnimatingActivityIndicator(activityView: self.activityView, controller: self)
            
            guard (success == true) else {
                self.presentAlertView(title: "Unable to Logout", message: error?.localizedDescription, actions: [UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)])
                return
            }
            
            if let result = result, result.count > 0 {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.presentAlertView(title: "Unable to Logout", message: "Please check your internet connection and try again.", actions: [UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)])
            }
        }
    }
    
    @IBAction func addOrOverwriteStudent(sender: AnyObject?) {
        if studentAlreadyPosted() {
            let overwriteAction = UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.default) {
                UIAlertAction in
                self.presentFindLocationVC(isBeingOverwritten: true)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            presentAlertView(title: "You Have Already Posted a Student Location. Would You Like to Overwrite?", message: nil, actions: [overwriteAction, cancelAction])
        } else {
            presentFindLocationVC(isBeingOverwritten: false)
        }
    }
}

// MARK: - MKMapView

extension MapViewController: MKMapViewDelegate {
    
    // Create a view with a "right callout accessory view".
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView?.canShowCallout = true
            pinView?.pinTintColor = .red
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
     
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle!, let url = URL(string: toOpen) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    // zoom level settings
    func setMapRegion(coordinateToZoom: CLLocationCoordinate2D) {
        let viewRegion = MKCoordinateRegionMakeWithDistance(coordinateToZoom, 300, 300)
        self.mapView.setRegion(viewRegion, animated: false)
    }
}

// MARK: - Convenience Methods

extension MapViewController {
    func fetchUserInformations() {
        getUdacityStudents {
            (success, error) in
            if success {
                performUIUpdatesOnMain {
                    self.addAnnotationsToMap(students: self.udacityStudents)
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }
}

// MARK: - Navigation

extension MapViewController {
    // unwind to MapViewController
    @IBAction func unwindToMapVC(sender: UIStoryboardSegue) {
        if let sourceVC = sender.source as? ShareLinkViewController, sourceVC.successfullyPosted == true {
            performUIUpdatesOnMain {
                self.fetchUserInformations()
                self.setMapRegion(coordinateToZoom: sourceVC.coordinate)
            }
        }
    }
    
    // present FindLocationVC
    func presentFindLocationVC(isBeingOverwritten: Bool) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "findLocationVC") as! FindLocationViewController
        controller.isBeingOverwritten = isBeingOverwritten
        self.present(controller, animated: true, completion: nil)
    }
}

// MARK: - Helper methods

extension MapViewController {
    
    // add annotations of students with their info. onto the map
    func addAnnotationsToMap(students: [StudentInformation]) {
        var annotations = [MKPointAnnotation]()
        // create an annotation and set its coordiate, title, and subtitle properties
        for student in students {
            let annotation = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: student.latitude, longitude: student.longitude)
            annotation.coordinate = coordinate
            annotation.title = "\(student.firstName) \(student.lastName)"
            annotation.subtitle = student.mediaURL
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
    }
    
    // populate udacityStudents with data
    func getUdacityStudents(completionHandlerForGetUdacityStudents: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        ParseClient.sharedInstance().getMultipleStudentLocations() {
            (success, error) in
            if success {
                performUIUpdatesOnMain {
                    let parsedStudents = ParseClient.sharedInstance().studentInformations
                    self.udacityStudents = parsedStudents
                    completionHandlerForGetUdacityStudents(true, nil)
                }
            } else {
                let error = NSError(domain: "getUdacityStudents", code: 0, userInfo: [NSLocalizedDescriptionKey: " getMultipleStudentLocations"])
                completionHandlerForGetUdacityStudents(false, error)
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
    
    // present alert view
    func presentAlertView(title: String?, message: String?, actions: [UIAlertAction]?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let actions = actions {
            for action in actions {
                alert.addAction(action)
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
