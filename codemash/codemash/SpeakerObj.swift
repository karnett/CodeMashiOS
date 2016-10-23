//
//  SpeakerModel.swift
//  codemash
//
//  Created by Kim Arnett on 10/19/16.
//  Copyright © 2016 karnett. All rights reserved.
//

import Foundation
import CoreData

class SpeakerObj: NSManagedObject {
    @nonobjc public class func fetchRequest(model: NSManagedObjectModel) -> NSFetchRequest<SpeakerObj> {
        return model.fetchRequestTemplate(forName: "GetSpeakers")! as! NSFetchRequest<SpeakerObj>
    }
    
    @nonobjc public class func getSpeakerWithId(model: NSManagedObjectModel, id: String) -> NSFetchRequest<SpeakerObj> {
        let fetchRequest = NSFetchRequest<SpeakerObj>(entityName: "SpeakerModel")
        fetchRequest.predicate = NSPredicate(format: "speakerId == %@", id)
        return fetchRequest
    }
    
    @NSManaged var speakerId: String?
    @NSManaged var biography: String? //2015-01-08T08:00:00
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    
    @NSManaged var gravatarUrl: String?
    @NSManaged var linkedInUrl: String?
    
    @NSManaged var githubUrl: String?
    @NSManaged var blogUrl: String?
    @NSManaged var twitterUrl: String?
    
    
}
