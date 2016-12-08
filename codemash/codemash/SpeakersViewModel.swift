//
//  SpeakersViewModel.swift
//  codemash
//
//  Created by Kim Arnett on 10/15/16.
//  Copyright © 2016 karnett. All rights reserved.
//

import Foundation

class SpeakersViewModel {
    var rest: RestController!
    var coreData: CoreDataController!
    
    var speakers: [SpeakerObj] = []
    var filtered: [SpeakerObj] = []
    
    var isFiltering = false
    var loadingSpeakers = false

    init(rest: RestController, coreData: CoreDataController) {
        self.rest = rest
        self.coreData = coreData
    }
    
    func loadSpeakers() {
        self.speakers = self.coreData.getSpeakers()
        
        if speakers.count == 0 && !loadingSpeakers {
            loadingSpeakers = true
            requestSpeakers()
        }
    }
    
    func requestSpeakers() {
        //move to core data
        self.rest.loadSpeakers(completionHandler: { result in
            
            self.loadingSpeakers = false
            switch result {
                
            case .success(let data):
                
                for entry in data {
                    self.coreData.saveSpeaker(json: entry)
                }
                
                self.speakers = self.coreData.getSpeakers()
                
                //send notification to reload table
                NotificationCenter.default.post(name: NotificationName.speakersLoaded, object: nil)

            case .failure(let error):
                //alert
                print(error)
            }
            
        })
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        
        if isFiltering {
            return filtered.count
        }
        
        return speakers.count
    }
    
    func getSpeakerAtIndex(row: Int) -> SpeakerObj? {
        if isFiltering && row < filtered.count {
            return filtered[row]
            
        }
        if !isFiltering && row < speakers.count {
            return speakers[row]
        }
        return nil
    }
    
    func getSessionsForSpeaker(id: String) -> [SessionObj] {
        return []
        //return self.coreData.getSessionsForSpeaker(id: id)
    }
    
    func filterSpeakers(text: String)
    {
        filtered = speakers.filter { speaker in
            let first = speaker.firstName?.lowercased() ?? ""
            let last = speaker.lastName?.lowercased() ?? ""
            
            return first.contains(text.lowercased()) || last.contains(text.lowercased())
        }
    }
}
