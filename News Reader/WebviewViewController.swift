//
//  WebviewViewController.swift
//  News Feed Application
//
//  Created by apple on 2017-11-22.
//  Copyright © 2017 Dmitrii Poliakov. All rights reserved.
//

import UIKit
import WebKit

class WebviewViewController: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    var article: Article?
    
    override func loadView() {
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let article = article{
            
            let articleURL = article.articleURL
            let urlRequest = URLRequest(url: URL(string: articleURL!)!)
            webView.load(urlRequest)
        }
    }

}
