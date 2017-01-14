//
//  SpeakerDetailsViewController.swift
//  codemash
//
//  Created by Kim Arnett on 10/8/16.
//  Copyright © 2016 karnett. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

class SpeakerDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var linkView: UIView!
    
    @IBOutlet weak var githubBtn: UIButton! //tag 0
    
    @IBOutlet weak var twitterBtn: UIButton! //tag 1
    
    @IBOutlet weak var linkedinBtn: UIButton! //tag 2
    
    @IBOutlet weak var blogBtn: UIButton! //tag 3
    
    
    var restController = RestController()
    
    let headerHeight: CGFloat = 45
    
    let webSegue = "showWeb"
    var speaker: SpeakerObj?
    var sessions: [SessionObj] = []
    
    var selectedURL = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 70.0
        self.tableView.separatorStyle = .none
        
        if speaker != nil {
            loadSpeakerView()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tabBarController?.tabBar.tintColor = UIColor.cmBlue()
        self.navigationController?.navigationBar.tintColor = UIColor.cmBlue()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func style()
    {
        self.profileImage.layer.masksToBounds = true
        self.profileImage.layer.cornerRadius = 50.0
        
        self.linkView.backgroundColor = UIColor.cmBlue()
        
        self.githubBtn.setImage(#imageLiteral(resourceName: "github").withRenderingMode(.alwaysTemplate), for: .normal)
        self.twitterBtn.setImage(#imageLiteral(resourceName: "twitter").withRenderingMode(.alwaysTemplate), for: .normal)
        self.linkedinBtn.setImage(#imageLiteral(resourceName: "linkedin").withRenderingMode(.alwaysTemplate), for: .normal)
        self.blogBtn.setImage(#imageLiteral(resourceName: "website").withRenderingMode(.alwaysTemplate), for: .normal)
        
        self.githubBtn.tintColor = UIColor.white
        self.twitterBtn.tintColor = UIColor.white
        self.linkedinBtn.tintColor = UIColor.white
        self.blogBtn.tintColor = UIColor.white
     
    }
    
    func loadSpeakerView() {
        let url = "https:"+(self.speaker?.gravatarUrl ?? "")
        self.profileImage.af_setImage(withURL: URL(string: url)!)
        self.backgroundImage.af_setImage(withURL: URL(string: url)!)
        
        if speaker?.firstName  == nil {
            self.nameLabel.text = speaker?.lastName
            
        } else {
            self.nameLabel.text = (speaker?.firstName ?? "") + " " + (speaker?.lastName ?? "")
            
        }
        
        
        if speaker?.blogUrl == nil || speaker?.blogUrl == "" {
            self.blogBtn.isEnabled = false
            self.blogBtn.tintColor = UIColor.lightGray
        }
        
        if speaker?.twitterUrl == nil || speaker?.twitterUrl == "" {
            self.twitterBtn.isEnabled = false
            self.twitterBtn.tintColor = UIColor.lightGray
        }
        
        if speaker?.linkedInUrl == nil || speaker?.linkedInUrl == "" {
            self.linkedinBtn.isEnabled = false
            self.linkedinBtn.tintColor = UIColor.lightGray
        }
        
        if speaker?.githubUrl == nil || speaker?.githubUrl == "" {
            self.githubBtn.isEnabled = false
            self.githubBtn.tintColor = UIColor.lightGray
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return sessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bioCell") as? BiographyTableViewCell
            
            cell?.textView.text = speaker?.biography ?? "Unavailable."
            return cell!
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "sessionsCell") as? SessionTableViewCell
        cell?.titleLabel.text = sessions[indexPath.row].title ?? "N/A"
        let session = self.sessions[indexPath.row]
        if session != nil {
            cell?.titleLabel.text = session.title ?? ""
            cell?.titleLabel.sizeToFit()
            let rooms: [String] = session.rooms ?? []
            
            var roomString = ""
            
            
            for index in 0..<rooms.count {
                
                roomString.append(rooms[index])
                
                if index != (rooms.count-1) {
                    roomString.append(", ")
                }
            }
            
            
            cell?.roomLabel.text = roomString
            cell?.timeLabel.text = getDayFromString(date: session.startTime)+getTimeFromString(startDate: session.startTime, endDate: session.endTime)
            
            if let id = session.sessionId {
                cell?.favoriteButton.isSelected = isSessionFavorite(id: Int(id))
            }
            
            if session.sessionType != "Kidz Mash" {
                cell?.kidzmashIcon.isHidden = true
            } else {
                
                cell?.kidzmashIcon.isHidden = false
            }
            
        }
        cell?.favoriteButton.tag = indexPath.row
        cell?.favoriteButton.addTarget(self, action: #selector(favoriteBtnSelected), for: .touchUpInside)
        
        
        return cell!
    }
    
    func favoriteBtnSelected(sender: UIButton) {
        let row = sender.tag
        print("Favorited item at: \(row)")
        let session = self.sessions[row]
        if let id = session.sessionId {
            favoriteSession(id: Int(id), isFavorited: sender.isSelected)
            sender.isSelected = !sender.isSelected
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableViewAutomaticDimension
        }
        return 100.0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let padding: CGFloat = 10.0
        let rect = CGRect(x: padding, y: 0, width: tableView.frame.width - (2*padding), height: self.headerHeight)
        let view = UIView(frame: rect)
        
        view.backgroundColor = UIColor.cmGrey()
        let label = UILabel(frame: rect)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.textColor = UIColor.black
        
        label.text = self.getTextForSection(section: section)
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func getTextForSection(section: Int) -> String {
        if section == 0 {
            return "Biography"
        }
        
        return "Sessions"
    }
    
    @IBAction func linkBtnPressed(_ sender: AnyObject) {
        
        print(sender.tag)
        switch (sender.tag) {
            case 0:
                self.selectedURL = speaker?.githubUrl ?? ""
            case 1:
                self.selectedURL = speaker?.twitterUrl ?? ""
            
            case 2:
                self.selectedURL = speaker?.linkedInUrl ?? ""
            case 3:
                self.selectedURL = speaker?.blogUrl ?? ""
            default:
                self.selectedURL = ""
        }
        
        if self.selectedURL != "" {
            self.performSegue(withIdentifier: webSegue, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == webSegue {
            let dest = segue.destination as? SpeakerWebViewController
            dest?.urlString = selectedURL
            
        }
    }
}
