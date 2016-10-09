//
//  Session.swift
//  codemash
//
//  Created by Kim Arnett on 10/8/16.
//  Copyright © 2016 karnett. All rights reserved.
//

import Foundation
import ObjectMapper

class Session: Mappable
{
    internal var sessionId: Int!
    internal var startTime: NSDate?
    internal var endTime: NSDate?
    internal var rooms: [String]?
    
    internal var title: String?
    internal var abstract: String?
    internal var sessionType: String? //General Session / Kidz Mash / Pre-Compiler
    
    
    internal var tags: [String]?
    internal var category: Category?
    internal var speakers: [SpeakerThin]?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    
    func mapping(map: Map)
    {
        sessionId <- map["Id"]
        startTime <- map["SessionStartTime"]
        endTime <- map["SessionEndTime"]
        rooms <- map["Rooms"]
        
        title <- map["Title"]
        abstract <- map["Abstract"]
        sessionType <- map["SessionType"]
        tags <- map["Tags"]
        category <- map["Category"]
        speakers <- map["Speakers"]
        
    }
}
