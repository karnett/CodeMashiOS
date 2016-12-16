//
//  SessionsViewModel.swift
//  codemash
//
//  Created by Kim Arnett on 10/8/16.
//  Copyright © 2016 karnett. All rights reserved.
//

import Foundation

class SessionsViewModel {
    var rest: RestController!
    var coreData: CoreDataController!
    
    var sessions: [SessionObj] = []
    
    var loadingSessions = false
    
    let prefs = UserDefaults.standard
    let favKey = "favoriteSessions"
    let updateKey = "serverUpdate"
    var currentDay: Day = .Tuesday //default
    
    init(rest: RestController, coreData: CoreDataController) {
        self.rest = rest
        self.coreData = coreData
    }
    
    func loadSessionsForDay(day: Day) {
        
        currentDay = day
        self.sessions = self.coreData.getSessionsForDay(day: (day.rawValue-1)) //start index at 0
        
        
        let needToLoad: Bool = (sessions.count == 0 && !loadingSessions)
        
        let dateRefreshed = self.getLastUpdateFromServer()
        let needToRefresh: Bool = (dateRefreshed == nil || numOfDays(first: dateRefreshed!, second: Date()) > 0)
        
        if needToLoad || needToRefresh {
            self.loadingSessions = true
            requestSessions()
        }
    }
    
    func requestSessions() {
        self.rest.loadSessions(completionHandler: { result in
            self.loadingSessions = false
            switch result {
                
                
            case .success(let data):
                
                for entry in data {
                    self.coreData.saveSession(json: entry)
                }
                
                self.sessions = self.coreData.getSessionsForDay(day: (self.currentDay.rawValue-1)) //start index at 0
                
                self.setLastUpdateFromServer()
                
                //send notification to reload table
                NotificationCenter.default.post(name: NotificationName.sessionsLoaded, object: nil)

            case .failure(let error):
                //alert
                print(error)
            }
            
        })
    }
    
    
    func numberOfRowsInSection(section: Int) -> Int {
        return sessions.count
    }
    
    func getSessionAtIndex(row: Int) -> SessionObj? {
        if row < sessions.count {
            return sessions[row]
        }
        return nil
    }
    
    func getSpeakersForSessions(id: String) -> [SpeakerThinJSON] {
        
        return self.coreData.getSpeakersForSession(id: id)
    }
    
    func numOfDays(first: Date, second: Date) -> Int {
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: first)
        let date2 = calendar.startOfDay(for: second)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)

        
        return components.day ?? 5 //default needs to be more than 1
    }
    
    func setLastUpdateFromServer() {
        prefs.set(Date(), forKey: updateKey)
    }
    
    func getLastUpdateFromServer() -> Date? {
        return prefs.object(forKey: updateKey) as? Date ?? nil
    }
    
        
}
