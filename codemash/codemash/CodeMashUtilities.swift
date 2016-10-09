//
//  CodeMashUtilities.swift
//  codemash
//
//  Created by Kim Arnett on 10/2/16.
//  Copyright © 2016 karnett. All rights reserved.
//

import UIKit
import Foundation



extension UIColor {
    
    
    public static func cmTeal() -> UIColor {
        return hexStringToUIColor(hex: "#3fbbae")
    }
    
    public static func cmBlue() -> UIColor {
        return hexStringToUIColor(hex: "#0c84a9")
    }
    
    public static func cmOrange() -> UIColor {
        return hexStringToUIColor(hex: "#f37d19")
    }
    public static func cmLime() -> UIColor {
        return hexStringToUIColor(hex: "#b6dd5e")
    }
    
    public static func cmGrey() -> UIColor {
        return hexStringToUIColor(hex: "#eaeaea")
    }
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString = cString.substring(from: cString.index(after: cString.startIndex))
    }
    
    if ((cString.characters.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
