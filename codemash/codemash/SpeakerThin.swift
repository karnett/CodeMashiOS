//
//  SpeakerThin.swift
//  codemash
//
//  Created by Kim Arnett on 10/8/16.
//  Copyright © 2016 karnett. All rights reserved.
//

import Foundation
import ObjectMapper

class SpeakerThin: Mappable
{
    internal var speakerId: String!
    internal var firstName: String?
    internal var lastName: String?
    internal var gravatarUrl: String?
    
    /*
     init(recipes: [Recipe], message: String, response: String)
     {
     self.recipes = recipes
     self.message = message
     self.response = response
     }*/
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map)
    {
        speakerId <- map["Id"]
        firstName <- map["FirstName"]
        lastName <- map["LastName"]
        gravatarUrl <- map["GravatarUrl"]
        
    }
}
