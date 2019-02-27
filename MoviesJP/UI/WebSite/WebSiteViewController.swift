//
//  WebSiteViewController.swift
//  MoviesJP
//
//  Created by iJPe on 2/27/19.
//  Copyright © 2019 jp. All rights reserved.
//

import Foundation
import UIKit
import WebKit

//MARK: - WebSiteViewController
class WebSiteViewController: UIViewController, UIWebViewDelegate {
    
    var url: String!
    
    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.load(NSURLRequest(url: NSURL(string: self.url)! as URL) as URLRequest)
    }
}
