//
//  MapViewController.swift
//  codemash
//
//  Created by Kim Arnett on 10/2/16.
//  Copyright © 2016 karnett. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    var restController = RestController()
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.tabBarController?.tabBar.tintColor = UIColor.cmOrange()
        self.tabBarController?.tabBar.setNeedsDisplay()
    }
    
}

