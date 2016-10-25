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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap))
        view.addGestureRecognizer(tapGesture)
        
        findOnMapButton.isEnabled = false
    }
    
    // MARK: - Actions
    
    @IBAction func findLocation(sender: AnyObject? = nil) {
        forwardGeocoding(address: mapStringTextField.text!)
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
        }
    }
}


// MARK: Geocoding

extension FindLocationViewController {
    func forwardGeocoding(address: String) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            guard (error == nil) else {
                print(error)
                return
            }
            
            guard let placemarks = placemarks, placemarks.count > 0 else {
                print("Couldn't get placemarks")
                return
            }
            
            let placemark = placemarks[0]
            let location = placemark.location
            let coordinate = location?.coordinate
            print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")

        })
    }
}
