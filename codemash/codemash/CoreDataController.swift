//
//  CoreDataController.swift
//  codemash
//
//  Created by Kim Arnett on 10/19/16.
//  Copyright © 2016 karnett. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import CoreData

class CoreDataController {
 
    func getSessions() -> [SessionObj]  {
        
        let request = SessionObj.fetchRequest(model:  self.getModel())
        
        do {
            let context = self.getContext()
            let results = try context.fetch(request) //(request) //as? [NSManagedObject]
            return results
        } catch{
            fatalError("Error is retriving Session items")
        }
        
        return []
    }
    
    
    func getSessionWithId(id: String) -> SessionObj? {
        let request = SessionObj.getSessionWithId(model: self.getModel(), id: id)
        do {
            let context = self.getContext()
            let results = try context.fetch(request) //(request) //as? [NSManagedObject]
            
            if results.count == 1 {
                return results[0]
            }
        } catch{
            fatalError("Error is retriving Speaker items")
        }
        
        return nil
    }
    
    
    func getSpeakers() -> [SpeakerObj]  {
        
        let request = SpeakerObj.fetchRequest(model:  self.getModel())
        
        do {
            let context = self.getContext()
            let results = try context.fetch(request) //(request) //as? [NSManagedObject]
            return results
        } catch{
            fatalError("Error is retriving Speaker items")
        }
        
        return []
    }
    
    func getSpeakerWithId(id: String) -> SpeakerObj? {
        let request = SpeakerObj.getSpeakerWithId(model: self.getModel(), id: id)
        do {
            let context = self.getContext()
            let results = try context.fetch(request) //(request) //as? [NSManagedObject]
            
            if results.count == 1 {
                return results[0]
            }
        } catch{
            fatalError("Error is retriving Speaker items")
        }
        
        return nil

    }
    
    func saveSession(json: SessionJSON) {
        
        
        let context = self.getContext()
        
        let exists = sessionExists(json: json) //if exists, it'll update, else insert
        
        if !exists {
            let session = NSEntityDescription.insertNewObject(forEntityName: "SessionModel", into: context)
            session.setValue(json.sessionId, forKey: "sessionId")
            session.setValue(json.startTime, forKey: "startTime")
            session.setValue(json.endTime, forKey: "endTime")
            
            session.setValue(json.rooms, forKey: "rooms")
            session.setValue(json.title, forKey: "title")
            session.setValue(json.abstract, forKey: "abstract")
            session.setValue(json.sessionType, forKey: "sessionType")
            // session.setValue(json.tags, forKey: "tags")
            session.setValue(json.category, forKey: "category")
            
            session.setValue(getDayIntForDate(time: json.startTime!), forKey: "day")
            
            let speakersJSON = Mapper().toJSONString(json.speakers!, prettyPrint: false)
            session.setValue(speakersJSON, forKey: "speakers")
            
            //save the object
            do {
                try context.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                
            }
        }
        
        
    }
    
    func sessionExists(json: SessionJSON) -> Bool {
        let request = SessionObj.getSessionWithId(model: self.getModel(), id: "\(json.sessionId!)")
        
        do {
            let context = self.getContext()
            let results = try context.fetch(request)
            
            if results.count > 0 {
                //record exists - update and return true to skip insert
                
                let session = results[0]

                session.setValue(json.sessionId, forKey: "sessionId")
                session.setValue(json.startTime, forKey: "startTime")
                session.setValue(json.endTime, forKey: "endTime")
                
                session.setValue(json.rooms, forKey: "rooms")
                session.setValue(json.title, forKey: "title")
                session.setValue(json.abstract, forKey: "abstract")
                session.setValue(json.sessionType, forKey: "sessionType")
                // session.setValue(json.tags, forKey: "tags")
                session.setValue(json.category, forKey: "category")
                
                session.setValue(getDayIntForDate(time: json.startTime!), forKey: "day")
                
                let speakersJSON = Mapper().toJSONString(json.speakers!, prettyPrint: false)
                session.setValue(speakersJSON, forKey: "speakers")
                
                //save the object
                
                try context.save()
                print("updated!")

                
                return true
            }
        } catch{
            fatalError("Error is retriving Speaker items")
        }
        
        return false
    }
    
    func getDayIntForDate(time: String) -> Int {
        
        if time.contains("2017-01-10") {
            return 0
        } else if time.contains("2017-01-11") {
            return 1
        } else if time.contains("2017-01-12") {
            return 2
        } else if time.contains("2017-01-13") {
            return 3
        }
        return 0
    }
    
    func saveSpeaker(json: SpeakerJSON) {
        
        
        let context = self.getContext()
        
        let exists = speakerExists(json: json) //if exists, udpated in method
        
        if !exists { //insert new
            let speaker = NSEntityDescription.insertNewObject(forEntityName: "SpeakerModel", into: context)
            
            speaker.setValue(json.biography, forKey: "biography")
            speaker.setValue(json.firstName, forKey: "firstName")
            speaker.setValue(json.lastName, forKey: "lastName")
            speaker.setValue(json.gravatarUrl, forKey: "gravatarUrl")
            speaker.setValue(json.linkedIn, forKey: "linkedInUrl")
            speaker.setValue(json.blog, forKey: "blogUrl")
            speaker.setValue(json.twitter, forKey: "twitterUrl")
            speaker.setValue(json.github, forKey: "githubUrl")
            speaker.setValue(json.speakerId, forKey: "speakerId")
            
            
            
            
            do {
                try context.save()
                print("speaker saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                
            }
        }
    }
    
    func speakerExists(json: SpeakerJSON) -> Bool {
        let request = SpeakerObj.getSpeakerWithId(model: self.getModel(), id: "\(json.speakerId!)")
        
        do {
            let context = self.getContext()
            let results = try context.fetch(request)
            
            if results.count > 0 {
                //record exists - update and return true to skip insert
                
                let speaker = results[0]
                
                speaker.setValue(json.biography, forKey: "biography")
                speaker.setValue(json.firstName, forKey: "firstName")
                speaker.setValue(json.lastName, forKey: "lastName")
                speaker.setValue(json.gravatarUrl, forKey: "gravatarUrl")
                speaker.setValue(json.linkedIn, forKey: "linkedInUrl")
                speaker.setValue(json.blog, forKey: "blogUrl")
                speaker.setValue(json.twitter, forKey: "twitterUrl")
                speaker.setValue(json.github, forKey: "githubUrl")
                speaker.setValue(json.speakerId, forKey: "speakerId")

                
                //save the object
                
                try context.save()
                print("speaker updated!")
                
                
                return true
            }
        } catch{
            fatalError("Error is retriving Speaker items")
        }
        
        return false
    }
    
    func getSessionsForDay(day: Int) -> [SessionObj] {
        let request = SessionObj.getSessionForDay(model: self.getModel(), day: day)
        do {
            let context = self.getContext()
            let results = try context.fetch(request) //(request) //as? [NSManagedObject]
            
            
            return results
        } catch{
            fatalError("Error is retriving Speaker items")
        }
        
        return []
    }
    
    func getSpeakersForSession(id: String) -> [SpeakerThinJSON] {
        let request = SessionObj.getSpeakersForSession(model: self.getModel(), id: id)
        do {
            let context = self.getContext()
            let results = try context.fetch(request) //(request) //as? [NSManagedObject]
            
            if results.count == 1 {
                return []
            }
        } catch{
            fatalError("Error is retriving Speaker items")
        }
        
        return []
    }
    
    
    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func getModel() -> NSManagedObjectModel {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.managedObjectModel
    }
}
