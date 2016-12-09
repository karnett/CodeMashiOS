//
//  AboutViewController.swift
//  codemash
//
//  Created by Kim Arnett on 10/2/16.
//  Copyright © 2016 karnett. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    @IBOutlet weak var headerView: UIView!
    
    var restController = RestController()
    
    @IBOutlet weak var githubBtn: KAButton!
    
    @IBOutlet weak var websiteBtn: KAButton!
    
    @IBOutlet weak var directionsBtn: KAButton!
    
    @IBOutlet weak var iconsBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.headerView.backgroundColor = UIColor.cmLime()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        style()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func style()
    {
        self.tabBarController?.tabBar.tintColor = UIColor.cmLime()
        
        self.websiteBtn.tintColor = UIColor.cmDarkGrey()
        self.directionsBtn.tintColor = UIColor.cmDarkGrey()
        self.iconsBtn.tintColor = UIColor.cmDarkGrey()
        
        self.websiteBtn.layer.borderColor = UIColor.cmOrange().cgColor
        self.websiteBtn.layer.borderWidth = 1.0
        self.websiteBtn.layer.cornerRadius = self.websiteBtn.frame.size.width/2
        
        
        self.directionsBtn.layer.borderColor = UIColor.cmLime().cgColor
        self.directionsBtn.layer.borderWidth = 1.0
        self.directionsBtn.layer.cornerRadius = self.directionsBtn.frame.size.width/2
        
        
        self.githubBtn.layer.borderColor = UIColor.cmBlue().cgColor
        self.githubBtn.layer.borderWidth = 1.0
        self.githubBtn.layer.cornerRadius = self.githubBtn.frame.size.width/2
        
    }
    
    
    @IBAction func websiteBntPressed(_ sender: AnyObject) {
        self.openURL(url: "http://codemash.org")
    }
    
    @IBAction func directionsBtnPressed(_ sender: AnyObject) {
        
        self.openURL(url: "http://maps.apple.com/?address=7000%20Kalahari%20Dr,Sandusky,OH,44870")
    }
    
    @IBAction func iconsBtnPressed(_ sender: AnyObject) {
        
        self.openURL(url: "https://icons8.com")
    }
    
    @IBAction func githubBtnPressed(_ sender: Any) {
        
        self.openURL(url: "https://github.com/karnett/CodeMashiOS")
    }
    
    func openURL(url: String) {
        UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
    }
    
}

