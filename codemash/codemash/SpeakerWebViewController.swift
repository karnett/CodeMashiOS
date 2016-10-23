//
//  SpeakerWebViewController.swift
//  codemash
//
//  Created by Kim Arnett on 10/22/16.
//  Copyright © 2016 karnett. All rights reserved.
//

import Foundation
import UIKit

class SpeakerWebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        webView.delegate = self
        
        let url = URL(string: urlString!)!
        webView.loadRequest(URLRequest(url: url))
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.activityIndicator.stopAnimating()
    }
    
}
