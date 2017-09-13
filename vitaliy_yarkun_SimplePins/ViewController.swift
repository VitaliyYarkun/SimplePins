//
//  ViewController.swift
//  vitaliy_yarkun_SimplePins
//
//  Created by Vitaliy Yarkun on 9/12/17.
//  Copyright © 2017 Vitaliy Yarkun. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        let url: URL = URL(string: "https://graph.facebook.com/oauth/authorize?client_id=1660470584023500&display=popup&response_type=code&redirect_uri=fb1660470584023500://authorize")!
        let request: URLRequest = URLRequest(url: url)
        //_ = Alamofire.request(request)
        
        webView.loadRequest(request)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        print("\(String(describing: request.url?.absoluteString))")
        var array: Array<String>?
        if request.url?.absoluteString.range(of:"fb1660470584023500://authorize/?code=") != nil {
          array  = request.url?.absoluteString.components(separatedBy: "code=")
        }
        if let codeString = array?.last {
            print("\(codeString)")
        }
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        //print("\(String(describing: webView.request?.url?.absoluteString))")
    }

}

