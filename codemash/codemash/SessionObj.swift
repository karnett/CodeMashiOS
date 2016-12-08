//
//  SessionModel.swift
//  codemash
//
//  Created by Kim Arnett on 10/19/16.
//  Copyright © 2016 karnett. All rights reserved.
//

import Foundation
import CoreData

class SessionObj: NSManagedObject {
    @nonobjc public class func fetchRequest(model: NSManagedObjectModel) -> NSFetchRequest<SessionObj> {
        return model.fetchRequestTemplate(forName: "GetSessions")! as! NSFetchRequest<SessionObj>
    }
    
    @nonobjc public class func getSpeakersForSession(model: NSManagedObjectModel, id: String) -> NSFetchRequest<SessionObj> {
        let fetchRequest = NSFetchRequest<SessionObj>(entityName: "SessionModel")
       // fetchRequest.predicate = NSPredicate(format: "speakerId == %@", id)
        return fetchRequest
    }
    
    @nonobjc public class func getSessionWithId(model: NSManagedObjectModel, id: String) ->NSFetchRequest<SessionObj> {
        let fetchRequest = NSFetchRequest<SessionObj>(entityName: "SessionModel")
        fetchRequest.predicate = NSPredicate(format: "sessionId == %@", id)
        return fetchRequest
    }
    
    @nonobjc public class func getSessionForDay(model: NSManagedObjectModel, day: Int) ->NSFetchRequest<SessionObj> {
        //DAY:
        //10 - 0
        //11 - 1
        //12 - 2
        //13 - 3
        
        let fetchRequest = NSFetchRequest<SessionObj>(entityName: "SessionModel")
        fetchRequest.predicate = NSPredicate(format: "day == %d", day)
        return fetchRequest
    }
    
    @NSManaged public var sessionId: NSNumber?
    @NSManaged public var day: NSNumber?
    @NSManaged public var startTime: String? //2015-01-08T08:00:00
    @NSManaged public var endTime: String?
    @NSManaged public var rooms: [String]?
    
    @NSManaged public var title: String?
    @NSManaged public var abstract: String?
    @NSManaged public var sessionType: String? //General Session / Kidz Mash / Pre-Compiler
    
    
    @NSManaged public var tags: [String]?
    @NSManaged public var category: String?
    @NSManaged public var speakers: String? //JSON STRING OF SPEAKERTHINGJSON
    
    
}
