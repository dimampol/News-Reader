//
//  WebviewViewController.swift
//  News Feed Application
//
//  Created by apple on 2017-11-22.
//  Copyright © 2017 Dmitrii Poliakov. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

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
            
            if webView.isLoading{
                SVProgressHUD.setDefaultMaskType(.black)
                SVProgressHUD.show(withStatus: "Loading...")
                SVProgressHUD.dismiss(withDelay: 12) //In case of slow Internet and if loading takes too long to allow viewing partially loaded content
            }
//            else{
//                SVProgressHUD.dismiss() // For fairly fast Internet
//            }
        }
    }
}
