//
//  LoginViewController.swift
//  vitaliy_yarkun_SimplePins
//
//  Created by Vitaliy Yarkun on 9/12/17.
//  Copyright © 2017 Vitaliy Yarkun. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var webView: UIWebView!
    
    //MARK: - Properties
    var loginCode: String?
    
    //MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        var request: URLRequest?
        
        do {
            request = try Router.login(client_id: Global.facebookClientID, redirect_uri: Global.facebookRedirectURI).asURLRequest()
        } catch {
           print("Error")
        }
        guard let lRequest = request else { return }
        
        self.showProgressBar()
        webView.loadRequest(lRequest)
    }

    fileprivate func getCodeParameter(from urlString: String?) {
        
        guard let urlString = urlString else { return }
        
        let separator = "code="
        guard (urlString.range(of:Global.facebookRedirectURI) != nil) &&  (urlString.range(of:separator) != nil) else { return }
        
        var array: Array<String>?
        array  = urlString.components(separatedBy: separator)
        
        if let codeString = array?.last {
            let finalCodeString = codeString.replacingOccurrences(of: "#_=_", with: "")
            loginCode = finalCodeString
            getToken()
        }
    }
    
    fileprivate func checkForError(in urlString: String?) {
        
        guard let urlString = urlString else { return }
        
        let errorKeywoard = "error=access_denied"
        guard (urlString.range(of:Global.facebookRedirectURI) != nil) &&  (urlString.range(of:errorKeywoard) != nil) else { return }
        self.clearCookies()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    fileprivate func getToken() {
        guard loginCode != nil else { return }
        self.showProgressBar()
        ServerManager().getAccessToken(client_id: Global.facebookClientID, redirect_uri: Global.facebookRedirectURI, client_secret: Global.facebookClientSecret, code: loginCode!) { (token) in
            if let token = token {
                ServerManager().inspect(token: token, appAccessToken: Global.facebookAppAccessToken, completion: { (userID, isValid) in
                    self.hideProgressBar()
                    if let userID = userID, let isValid = isValid, isValid {
                        let lVC = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                        lVC.userID = userID
                        lVC.token = token
                        self.navigationController?.pushViewController(lVC, animated: true)
                    }
                })
                
            } else {
                self.hideProgressBar()
            }
        }
    }
}

//MARK: - UIWebViewDelegate
extension LoginViewController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        getCodeParameter(from: request.url?.absoluteString)
        checkForError(in: request.url?.absoluteString)
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.hideProgressBar()
    }
}










