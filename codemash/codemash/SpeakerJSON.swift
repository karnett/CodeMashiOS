//
//  Speaker.swift
//  codemash
//
//  Created by Kim Arnett on 10/15/16.
//  Copyright © 2016 karnett. All rights reserved.
//

import Foundation
import ObjectMapper

class SpeakerJSON: Mappable
{
    internal var speakerId: String!
    internal var firstName: String?
    internal var lastName: String?
    internal var biography: String?
    internal var gravatarUrl: String?
    internal var twitter: String?
    internal var github: String?
    internal var linkedIn: String?
    internal var blog: String?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    
    func mapping(map: Map)
    {
        speakerId <- map["Id"]
        firstName <- map["FirstName"]
        lastName <- map["LastName"]
        biography <- map["Biography"]
        gravatarUrl <- map["GravatarUrl"]
        twitter <- map["TwitterLink"]
        github <- map["GitHubLink"]
        linkedIn <- map["LinkedInProfile"]
        blog <- map["BlogUrl"]
    }
}
