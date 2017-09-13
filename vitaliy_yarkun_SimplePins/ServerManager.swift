//
//  ServerManager.swift
//  vitaliy_yarkun_SimplePins
//
//  Created by Vitaliy Yarkun on 9/13/17.
//  Copyright © 2017 Vitaliy Yarkun. All rights reserved.
//

import Alamofire

protocol ServiceProtocol {
    
    @discardableResult
    func request(_ request: URLRequestConvertible) -> DataRequest
}

class ServerManager {
    
    //MARK: - Completions
    typealias GetTokenCompletion = (_ token: String?) -> Void
    
    //MARK: - Properties
    lazy var service: ServiceProtocol = AlamofireService()
    
    //MARK: - Request methods
    @discardableResult
    func getAccessToken(client_id: String, redirect_uri: String, client_secret: String, code: String, completion: @escaping GetTokenCompletion) -> DataRequest {
        let request = Router.getAccessToken(client_id: client_id, redirect_uri: redirect_uri, client_secret: client_secret, code: code)
        return self.service.request(request)
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: { (response) in
                var token: String?
                
                switch response.result {
                case .success(let JSON):
                    if let responseJSON = JSON as? [String : Any] {
                        token = responseJSON["access_token"] as? String
                    }
                case .failure:
                    break;
                }
                completion(token)
            })
    }
}


    
    


















