//
//  EnterLocationViewController.swift
//  On The Map
//
//  Created by Abidi on 10/25/16.
//  Copyright © 2016 com.AliMir. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBookUI

class FindLocationViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var mapStringTextField: UITextField!
    @IBOutlet weak var findOnMapButton: UIButton!
    
    let defaultMapStringTextField = "Enter Your Location Here"
    var activityIndicatorView = UIActivityIndicatorView()
    var isBeingOverwritten: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap))
        view.addGestureRecognizer(tapGesture)
        
        findOnMapButton.isEnabled = false
        findOnMapButton.alpha = 0.5
    }
    
    // MARK: - Actions
    
    @IBAction func findLocation(sender: AnyObject? = nil) {
        
        // start animating activity indicator
        ActivityIndicatorView.startAnimatingActivityIndicator(activityView: self.activityIndicatorView, controller: self, style: .whiteLarge)
        
        getCoordinateOfMapString(address: mapStringTextField.text!) { (coordinate, error) in
            
            // stop animating activity indicator
            ActivityIndicatorView.stopAnimatingActivityIndicator(activityView: self.activityIndicatorView, controller: self)
            
            func presentError(error: String) {
                let alert = UIAlertController(title: error, message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            guard (error == nil) else {
                presentError(error: (error?.localizedDescription)!)
                return
            }
            
            if let coordinate = coordinate {
                self.toShareLinkViewController(coordinate: coordinate)
            } else {
                presentError(error: "Could not get the coordinates. Please try again.")
            }
            
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func tap(gesture: UITapGestureRecognizer) {
        mapStringTextField.resignFirstResponder()
    }
}


// MARK: - UITextFieldDelegate

extension FindLocationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if mapStringTextField.text == defaultMapStringTextField {
            mapStringTextField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if mapStringTextField.text != "" {
            textField.resignFirstResponder()
            findLocation()
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if mapStringTextField.text == "" {
            mapStringTextField.text = defaultMapStringTextField
        } else {
            findOnMapButton.isEnabled = true
            findOnMapButton.alpha = 1.0
        }
    }
}


// MARK: Geocoding

extension FindLocationViewController {
    func getCoordinateOfMapString(address: String, completionHandler: @escaping (_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> Void) {
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            
            guard (error == nil) else {
                completionHandler(nil, error)
                return
            }
            
            guard let placemarks = placemarks, placemarks.count > 0 else {
                completionHandler(nil, NSError(domain: "forwardGeocoding", code: 0, userInfo: [NSLocalizedDescriptionKey : "Could not find your location."]))
                return
            }
            
            let placemark = placemarks[0]
            let location = placemark.location
            let coordinate = location?.coordinate
            completionHandler(coordinate, nil)

        }
    }
}


// MARK: Navigation
extension FindLocationViewController {
    
    // transition to ShareLink view controller
    func toShareLinkViewController(coordinate: CLLocationCoordinate2D) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "shareLinkVC") as! ShareLinkViewController
        controller.coordinate = coordinate
        controller.mapString = mapStringTextField.text
        controller.isBeingOverwritten = isBeingOverwritten
        self.present(controller, animated: false, completion: nil)
    }
}





