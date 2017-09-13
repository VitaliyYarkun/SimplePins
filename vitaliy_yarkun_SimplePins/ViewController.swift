//
//  ViewController.swift
//  vitaliy_yarkun_SimplePins
//
//  Created by Vitaliy Yarkun on 9/12/17.
//  Copyright © 2017 Vitaliy Yarkun. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        var request: URLRequest?
        
        do {
            request = try Router.login(client_id: Global.facebookClientID, redirect_uri: Global.facebookRedirectURI).asURLRequest()
        } catch {
           print("Error")
        }
        
        webView.loadRequest(request!)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        print("\(String(describing: request.url?.absoluteString))")
        var array: Array<String>?
        if request.url?.absoluteString.range(of:Global.facebookRedirectURI) != nil {
          array  = request.url?.absoluteString.components(separatedBy: "code=")
        }
        if let codeString = array?.last {
            print("\(codeString)")
        }
        return true
    }
}

