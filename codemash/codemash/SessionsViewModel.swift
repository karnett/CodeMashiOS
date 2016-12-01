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
    
    let prefs = UserDefaults.standard
    let favKey = "favoriteSessions"
    
    init(rest: RestController, coreData: CoreDataController) {
        self.rest = rest
        self.coreData = coreData
    }
    
    func loadSessionsForDay(day: Day) {
        
        
        self.sessions = self.coreData.getSessions()
        
        if sessions.count == 0 {
            requestSessions()
        }
    }
    
    func requestSessions() {
        self.rest.loadSessions(completionHandler: { result in
            
            switch result {
                
            case .success(let data):
                
                for entry in data {
                    self.coreData.saveSession(json: entry)
                }
                
                self.sessions = self.coreData.getSessions()
                
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
    
    func favoriteSession(id: String, isFavorited: Bool) {
        var favorites = prefs.array(forKey: favKey) ?? []
        favorites.append(id)
        
        prefs.set(favorites, forKey: favKey)
    }
    
    func getFavorites() -> [SessionObj] {
        let favorites: [String] = prefs.object(forKey: favKey) as? [String] ?? []
        var sessions: [SessionObj] = []
        for fav in favorites {
            if let session = self.getSessionWithId(id: fav) {
                sessions.append(session)
            }
        }
        
        return sessions
    }
    
    func getSessionWithId(id: String) -> SessionObj? {
        return self.coreData.getSessionWithId(id: id)
    }
    
    func isSessionFavorite(id: String) -> Bool {
        let favorites = self.getFavorites()
        for fav in favorites {
            if "\(fav.sessionId!)" == id {
                return true
            }
        }
        return false
    }
    
}
