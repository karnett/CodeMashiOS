//
//  SpeakersViewModel.swift
//  codemash
//
//  Created by Kim Arnett on 10/15/16.
//  Copyright © 2016 karnett. All rights reserved.
//

import Foundation

class SpeakersViewModel {
    var rest: RestController?
    
    var speakers: [SpeakerJSON] = []
    var filtered: [SpeakerJSON] = []
    
    var isFiltering = false
    init(rest: RestController) {
        self.rest = rest
    }
    
    func loadSpeakers() {
        
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        
        if isFiltering {
            return filtered.count
        }
        
        return speakers.count
    }
    
    func getSpeakerAtIndex(row: Int) -> SpeakerJSON? {
        if isFiltering && row < filtered.count {
            return filtered[row]
            
        }
        if !isFiltering && row < speakers.count {
            return speakers[row]
        }
        return nil
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
