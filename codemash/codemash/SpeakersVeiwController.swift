//
//  SpeakersVeiwController.swift
//  codemash
//
//  Created by Kim Arnett on 10/2/16.
//  Copyright © 2016 karnett. All rights reserved.
//

import UIKit

class SpeakersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var restController = RestController()
    let detailSegue: String = "showDetails" //Speaker Details
    let headerHeight: CGFloat = 200.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        self.edgesForExtendedLayout = .all
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        style()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func style()
    {
        self.tabBarController?.tabBar.tintColor = UIColor.cmBlue()
        self.navigationController?.navigationBar.tintColor = UIColor.cmBlue()
        self.navigationItem.title = "Speakers"
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "speakersCell")
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: detailSegue, sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let rect = CGRect(x: 0, y: 0, width: tableView.frame.width, height: self.headerHeight)
        let view = UIView(frame: rect)
        view.backgroundColor = UIColor.cmBlue()
        let label = UILabel(frame: rect)
        label.textAlignment = .center
        label.text = "Speakers"
        label.font = UIFont.boldSystemFont(ofSize: 30.0)
        label.textColor = UIColor.white
        view.addSubview(label)
        return view
    }
    
    
    
}

