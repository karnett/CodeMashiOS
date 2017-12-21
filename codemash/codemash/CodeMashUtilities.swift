//
//  CodeMashUtilities.swift
//  codemash
//
//  Created by Kim Arnett on 10/2/16.
//  Copyright © 2016 karnett. All rights reserved.
//

import UIKit
import Foundation

let prefs = UserDefaults.standard
let favKey = "favoriteSessions"
let filterKey = "filterSessions"
let coreDataUtil = CoreDataController()

let filters: [String] = [".NET",
                         "Cloud/Big Data",
                         "Design (UI/UX/CSS)",
                         "Events",
                         "Functional Programming",
                         "Hardware",
                         "Java",
                         "JavaScript",
                         "Mobile",
                         "Other",
                         "Ruby/Rails",
                         "Security",
                         "Soft Skills / Business",
                         "Testing"]

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
    
    public static func cmDarkGrey() -> UIColor {
        return hexStringToUIColor(hex: "#333333")
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

func getTimeFromString(startDate: String?, endDate: String?) -> String {
    
    if startDate == nil {
        return "N/A"
    }
    
    let dateForm = DateFormatter()
    dateForm.dateFormat = "YYYY-MM-DD'T'HH:mm:ss"
    
    let start = dateForm.date(from: startDate!)
    
    if endDate == nil {
        dateForm.dateFormat = "hh:mm a"
        return "\n\(dateForm.string(from: start!))"
    }
    
    let end = dateForm.date(from: endDate!)
    
    dateForm.dateFormat = "hh:mm a"
    return "\(dateForm.string(from: start!))\nto \(dateForm.string(from: end!))"
}

func getDayFromString(date: String?) -> String {
    
    if date == nil {
        return "N/A"
    }
    
    let dateForm = DateFormatter()
    dateForm.dateFormat = "YYYY-MM-DD'T'HH:mm:ss"
    
    let start = dateForm.date(from: date!)
    
    dateForm.dateFormat = "EEEE"
    return "\(dateForm.string(from: start!)) "
}

func favoriteSession(id: Int, isFavorited: Bool) {
    var favorites: [Int] = prefs.array(forKey: favKey) as? [Int] ?? []
    
    if !isFavorited {
        favorites.append(id)
    } else {
        favorites = favorites.filter({ $0 != id })
    }

    prefs.set(favorites, forKey: favKey)
}

func getSessionWithId(id: String) -> SessionObj? {
    return coreDataUtil.getSessionWithId(id: id)
}

func isSessionFavorite(id: Int) -> Bool {
    let favorites = prefs.array(forKey: favKey) as? [Int] ?? []
    for fav in favorites {
        if fav == id {
            return true
        }
    }
    return false
}
