//
//  Tag.swift
//  codemash
//
//  Created by Kim Arnett on 10/20/17.
//  Copyright © 2017 karnett. All rights reserved.
//

import Foundation
enum Tag: String {
    case NET = ".NET"
    case Cloud = "Cloud/Big Data"
    case Design = "Design (UI/UX/CSS), Testing"
    case Events
    case Functional = "Functional Programming"
    case Hardware
    case Java
    case JavaScript
    case Mobile
    case Other
    case Ruby = "Ruby/Rails"
    case Security
    case Soft = "Soft Skills / Business"
    case Testing
    
    static let allValues = [NET, Cloud, Design, Events, Functional, Hardware, Java, JavaScript, Mobile, Other, Ruby, Security, Soft, Testing]
}
