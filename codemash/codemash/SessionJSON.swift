//
//  Session.swift
//  codemash
//
//  Created by Kim Arnett on 10/8/16.
//  Copyright © 2016 karnett. All rights reserved.
//

import Foundation
import ObjectMapper


class SessionJSON: Mappable
{
    internal var sessionId: Int!
    internal var startTime: String? //2015-01-08T08:00:00
    internal var endTime: String?
    internal var rooms: [String]?
    
    internal var title: String?
    internal var abstract: String?
    internal var sessionType: String? //General Session / Kidz Mash / Pre-Compiler
    
    
    internal var tags: [String]?
    internal var category: String?
    internal var speakers: [SpeakerThinJSON]?
    
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
