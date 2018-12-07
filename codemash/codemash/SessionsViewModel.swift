//
//  SessionsViewModel.swift
//  codemash
//
//  Created by Kim Arnett on 10/8/16.
//  Copyright © 2016 karnett. All rights reserved.
//

import Foundation
import ObjectMapper

class SessionsViewModel {
    var rest: RestController!
    var coreData: CoreDataController!
    
    var sessions: [SessionObj] = []
    var loadingSessions = false
    
    let prefs = UserDefaults.standard
    let favKey = "favoriteSessions"
    let updateKey = "serverUpdate"
    var currentDay: Day = getSelectedDay() { //returns selectedSessionDayKey, today, or default Tuesday
        didSet {
            self.refreshSessions()
            setSelectedDay(day: currentDay) //sets the current day to the selected day on the UserDefaults
        }
    }
    
    init(rest: RestController, coreData: CoreDataController) {
        self.rest = rest
        self.coreData = coreData
    }
    
    func checkForOldEntries() {
        //make sure previous years data is gone.
        let oldEntries = self.coreData.getOldSessions()
        //if there are old entries - clear out old data and get new speakers and sessions. Leave favorites alone for now.
        if oldEntries.count > 1 {
            self.clearLastUpdateFromServer()
            self.coreData.clearTables()
         }
    }
    
    private func refreshSessions() {
        //apply filter and day if it's changed.
        self.sessions = self.coreData.getSessionsForDay(day: (currentDay.rawValue-1))

        let dateRefreshed = self.getLastUpdateFromServer()
        let needToRefresh: Bool = (dateRefreshed == nil || numOfDays(first: dateRefreshed!, second: Date()) > 0)

        if needToRefresh {
            requestSessions()
        }
        
        let selectedFilters: [Int] = prefs.array(forKey: filterKey) as? [Int] ?? []
        
        var filteredSessions: [SessionObj] = []
        if selectedFilters.count > 0 {
            //if there are selected filters - go through the sessions and remvoe those who don't match
            for session in self.sessions {
                var sessionMatchesFilter = false
                for filterIndex in selectedFilters {
                    let filter = filters[filterIndex]
                    sessionMatchesFilter = session.tags?.contains(filter) ?? false
                    
                    if sessionMatchesFilter {
                        filteredSessions.append(session)
                    }
                }
            }
        } else {
           filteredSessions = self.sessions
        }
        
        self.sessions = filteredSessions
        
        //send notification to reload table
        NotificationCenter.default.post(name: NotificationName.sessionsLoaded, object: nil)
    }
    
    func loadSessionsFromFile() {
        if let path = Bundle.main.path(forResource: "old_data", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let sessions = Mapper<SessionJSON>().mapArray(JSONObject: json)!
                for entry in sessions {
                    self.coreData.saveSession(json: entry)
                }
                
                self.sessions = self.coreData.getSessionsForDay(day: (self.currentDay.rawValue-1)) //start index at 0
                
                self.setLastUpdateFromServer()
                
                //send notification to reload table
                NotificationCenter.default.post(name: NotificationName.sessionsLoaded, object: nil)
                
            } catch {
                // handle error
            }
        }
    }
    
    func getFilterButtonText() -> String {
        let filterCount = prefs.array(forKey: filterKey)?.count ?? 0
        if filterCount > 0 {
            return "Filter (\(filterCount))"
        }
        return "Filter"        
    }
    
    func requestSessions() {
        self.loadingSessions = true
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
    
    func clearLastUpdateFromServer() {
        prefs.set(nil, forKey: updateKey)
    }
    
    func setLastUpdateFromServer() {
        prefs.set(Date(), forKey: updateKey)
    }
    
    func getLastUpdateFromServer() -> Date? {
        return prefs.object(forKey: updateKey) as? Date ?? nil
    }
}
