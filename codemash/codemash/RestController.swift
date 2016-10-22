//
//  RestController.swift
//  codemash
//
//  Created by Kim Arnett on 10/2/16.
//  Copyright © 2016 karnett. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import UIKit

class RestController {
    
    var alamoFireManager = Alamofire.SessionManager.default

    
    func loadSessions(completionHandler: @escaping (Result<[SessionJSON]>) -> Void)
    {
        let url = "https://speakers.codemash.org/api/SessionsData?type=json"
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        self.alamoFireManager.request(url).responseJSON(completionHandler: {
            response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            print(response.result)
            switch response.result {
                
                case .success(let data):
                    let sessions = Mapper<SessionJSON>().mapArray(JSONObject: data)
                    completionHandler(Result.success(sessions!))
                case .failure(let error):
                   completionHandler(Result.failure(error))
            }
        })
    }
    
    func loadSpeakers(completionHandler: @escaping (Result<[SpeakerJSON]>) -> Void) {
        let url = "https://speakers.codemash.org/api/SpeakersData?type=json"
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.alamoFireManager.request(url).responseJSON(completionHandler: {
            response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            print(response.result)
            switch response.result {
                
                case .success(let data):
                    let sessions = Mapper<SpeakerJSON>().mapArray(JSONObject: data)
                    completionHandler(Result.success(sessions!))
                case .failure(let error):
                    completionHandler(Result.failure(error))
            }
        })

    }
}
