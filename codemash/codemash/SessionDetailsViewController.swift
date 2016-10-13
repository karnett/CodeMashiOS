//
//  SessionDetailsViewController.swift
//  codemash
//
//  Created by Kim Arnett on 10/8/16.
//  Copyright © 2016 karnett. All rights reserved.
//

import Foundation
import UIKit

class SessionDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var roomLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    //Buttons
    let session: Session? = nil
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
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.cmTeal()
        self.tabBarController?.tabBar.tintColor = UIColor.cmTeal()
        self.headerView.backgroundColor = UIColor.cmTeal()
    }
    
    //TableView
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "abstractCell")
            
            return cell!
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "speakersCell")
        
        return cell!
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
            label.text = "10:00 AM - 11:00 AM\nSoft Skills"
        } else if section == 1 {
            label.text = "Speakers"
            
        }
        
        view.addSubview(label)
        return view
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: detailSegue, sender: self)
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
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableViewAutomaticDimension
        }
        return 70.0
    }

    
}
