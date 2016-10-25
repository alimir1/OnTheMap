//
//  ActivityIndicatorView.swift
//  On The Map
//
//  Created by Abidi on 10/25/16.
//  Copyright © 2016 com.AliMir. All rights reserved.
//

import UIKit

struct ActivityIndicatorView {
    static func startAnimatingActivityIndicator(activityView: UIActivityIndicatorView, controller: UIViewController, style: UIActivityIndicatorViewStyle) {
        activityView.center = controller.view.center
        activityView.activityIndicatorViewStyle = style
        activityView.startAnimating()
        controller.view.addSubview(activityView)
    }
    static func stopAnimatingActivityIndicator(activityView: UIActivityIndicatorView, controller: UIViewController) {
        activityView.stopAnimating()
        activityView.removeFromSuperview()
    }
}
