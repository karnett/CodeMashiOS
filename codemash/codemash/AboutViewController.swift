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
    }
    
}

