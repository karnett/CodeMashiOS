//
//  UIViewController+Utilities.swift
//  codemash
//
//  Created by Kim Arnett on 11/17/17.
//  Copyright © 2017 karnett. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    //Show an alert window with the specified title
    func sendAlert(title: String) {
        let alertWindow = UIAlertController.init(title: title, message: "", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            alertWindow.dismiss(animated: true, completion: nil)
        })
        alertWindow.addAction(okBtn)
        self.present(alertWindow, animated: true, completion: nil)
    }
    
    func delay(seconds: Double, completionHandler: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: {
            completionHandler()
        })
    }
}
