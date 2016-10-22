//
//  CoreDataController.swift
//  codemash
//
//  Created by Kim Arnett on 10/19/16.
//  Copyright © 2016 karnett. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class CoreDataController {
 
    func getSessions() -> [SessionObj]  {
        
        let request = SessionObj.fetchRequest(model:  self.getModel())
        
        do {
            let context = self.getContext()
            let results = try context.fetch(request) //(request) //as? [NSManagedObject]
            return results
        } catch{
            fatalError("Error is retriving Gorcery items")
        }
        
        return []
    }
    
    func getSpeakers() -> [SpeakerObj]  {
        
        let request = SpeakerObj.fetchRequest(model:  self.getModel())
        
        do {
            let context = self.getContext()
            let results = try context.fetch(request) //(request) //as? [NSManagedObject]
            return results
        } catch{
            fatalError("Error is retriving Gorcery items")
        }
        
        return []
    }
    
    func saveSession(json: SessionJSON) {
        
        
        let context = self.getContext()
        
        //retrieve the entity that we just created
        let session = NSEntityDescription.insertNewObject(forEntityName: "SessionModel", into: context)
        session.setValue(json.sessionId, forKey: "sessionId")
        session.setValue(json.startTime, forKey: "startTime")
        session.setValue(json.endTime, forKey: "endTime")
        //session.setValue(json.rooms, forKey: "rooms")
        session.setValue(json.title, forKey: "title")
        session.setValue(json.abstract, forKey: "abstract")
        session.setValue(json.sessionType, forKey: "sessionType")
        // session.setValue(json.tags, forKey: "tags")
        session.setValue(json.category, forKey: "category")
        //session.setValue(json.speakers, forKey: "speakers")
        //save the object
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func getModel() -> NSManagedObjectModel {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.managedObjectModel
    }
}
