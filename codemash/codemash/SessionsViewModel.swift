//
//  SessionsViewModel.swift
//  codemash
//
//  Created by Kim Arnett on 10/8/16.
//  Copyright © 2016 karnett. All rights reserved.
//

import Foundation

class SessionsViewModel {
    var rest: RestController?
    
    var sessions: [Session] = []
    
    init(rest: RestController) {
        self.rest = rest
    }
    
    func loadSessionsForDay(day: Day) {
        
    }
}
