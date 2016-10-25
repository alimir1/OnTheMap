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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserInformations()
    }
    
    // MARK: - Actions
    @IBAction func refreshMap(sender: AnyObject) {
        fetchUserInformations()
    }
}

// MARK: - MKMapViewDelegate

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

}
