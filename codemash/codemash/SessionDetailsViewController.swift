//
//  SessionDetailsViewController.swift
//  codemash
//
//  Created by Kim Arnett on 10/8/16.
//  Copyright © 2016 karnett. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class SessionDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var roomLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    //Buttons
    var session: SessionObj?
    var timeString: String = "N/A"
    var speakers: Array<SpeakerThinJSON> = []
    
    let headerHeight: CGFloat = 45
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 70.0
        
        
        self.edgesForExtendedLayout = .all
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        style()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func style()
    {
        
       // self.roomLabel.text = session?.rooms ?? "Unavailable"
        self.titleLabel.text = session?.title ?? "Unavailable"
        
        let rooms: [String] = session?.rooms ?? []
        
        var roomString = ""
        
        
        for index in 0..<rooms.count {
            
            roomString.append(rooms[index])
            
            if index != (rooms.count-1) {
                roomString.append(", ")
            }
        }
        
        self.roomLabel.text = roomString
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.cmTeal()
        self.tabBarController?.tabBar.tintColor = UIColor.cmTeal()
        self.headerView.backgroundColor = UIColor.cmTeal()
    }
    
    //TableView
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "abstractCell") as? BiographyTableViewCell
            cell?.textView.text = self.session?.abstract ?? "Abstract is currently unavailable."
            return cell!
        }
        let speaker = self.speakers[indexPath.row]
        
        let speakerCell = tableView.dequeueReusableCell(withIdentifier: "speakersCell") as? SpeakerTableViewCell
        
        if speaker.gravatarUrl != nil {
            let url = "https:"+(speaker.gravatarUrl ?? "")
            speakerCell?.profileImg.af_setImage(withURL: URL(string: url)!)
        }
        
        speakerCell?.nameLabel.text = "\(speaker.firstName ?? "") \(speaker.lastName ?? "")"
       
        
        
        return speakerCell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let rect = CGRect(x: 0, y: 0, width: tableView.frame.width, height: self.headerHeight)
        let view = UIView(frame: rect)
        view.backgroundColor = UIColor.cmGrey()
        let label = UILabel(frame: rect)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.textColor = UIColor.black
        
        if section == 0 {
            label.numberOfLines = 2
            self.timeString = self.timeString.replacingOccurrences(of: "\n", with: " ")
            
            let cateogry = session?.category ?? "Unknown"
            label.text = "\(self.timeString)\n\(cateogry)"
        } else if section == 1 {
            label.text = "Speakers"
            
        }
        
        view.addSubview(label)
        return view
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //jump to speaker details
        self.navigationController?.tabBarController?.selectedIndex = 1
        //send notification
        
        let speaker = self.speakers[indexPath.row]
        NotificationCenter.default.post(name: NotificationName.speakerSelected, object: speaker.speakerId)
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.headerHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            
            self.speakers = Mapper<SpeakerThinJSON>().mapArray(JSONString: (session?.speakers)!) ?? []
            return self.speakers.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        }
        return 70.0
    }
    
}
