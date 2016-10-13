//
//  SpeakerDetailsViewController.swift
//  codemash
//
//  Created by Kim Arnett on 10/8/16.
//  Copyright © 2016 karnett. All rights reserved.
//

import Foundation
import UIKit

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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 70.0
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bioCell")
            
            return cell!
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "sessionsCell")
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableViewAutomaticDimension
        }
        return 70.0
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
    
    func getTextForSection(section: Int) -> String {
        if section == 0 {
            return "Biography"
        }
        
        return "Sessions"
    }
    
    @IBAction func linkBtnPressed(_ sender: AnyObject) {
        
        print(sender.tag)
    }
    
    
    
}
