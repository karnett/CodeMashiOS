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
    
    
    @IBOutlet weak var websiteBtn: UIButton!
    
    @IBOutlet weak var directionsBtn: UIButton!
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func style()
    {
        self.tabBarController?.tabBar.tintColor = UIColor.cmLime()
        
        self.websiteBtn.tintColor = UIColor.cmTeal()
        self.directionsBtn.tintColor = UIColor.cmTeal()
        self.iconsBtn.tintColor = UIColor.cmTeal()
    }
    
    @IBAction func websiteBntPressed(_ sender: AnyObject) {
        
        UIApplication.shared.openURL(URL(string: "http://codemash.org")!)
    }
    
    @IBAction func directionsBtnPressed(_ sender: AnyObject) {
        
        UIApplication.shared.openURL(URL(string: "http://maps.apple.com/?address=7000%40Kalahari%40Dr,Sandusky,OH,44870")!)
    }
    
    @IBAction func iconsBtnPressed(_ sender: AnyObject) {
    }
    
    
}

