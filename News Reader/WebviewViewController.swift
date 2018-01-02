//
//  WebviewViewController.swift
//  News Feed Application
//
//  Created by apple on 2017-11-22.
//  Copyright © 2017 Dmitrii Poliakov. All rights reserved.
//

import UIKit

class WebviewViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    var article: Article?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        if let article = article{
            
            let articleURL = article.articleURL
            let urlRequest = URLRequest(url: URL(string: articleURL!)!)
            webView.loadRequest(urlRequest)
        }
    }

}
