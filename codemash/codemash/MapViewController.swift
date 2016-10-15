//
//  MapViewController.swift
//  codemash
//
//  Created by Kim Arnett on 10/2/16.
//  Copyright © 2016 karnett. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var restController = RestController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.contentSize = self.imageView.frame.size
        self.scrollView.delegate = self
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
        self.scrollView.zoomScale = 1.0
        self.tabBarController?.tabBar.tintColor = UIColor.cmOrange()
        self.tabBarController?.tabBar.setNeedsDisplay()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
       
        return self.imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
       // <#code#>
    }
    
}

