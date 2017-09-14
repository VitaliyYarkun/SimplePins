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

final class ServerManager {
    
    //MARK: - Completions
    typealias GetTokenCompletion = (_ token: String?) -> Void
    typealias InspectTokenCompletion = (_ userID: String?, _ isTokenValid: Bool?) -> Void
    
    //MARK: - Properties
    private let validCodes = 200..<300
    lazy var service: ServiceProtocol = AlamofireService()
    
    //MARK: - Request methods
    @discardableResult
    func getAccessToken(client_id: String, redirect_uri: String, client_secret: String, code: String, completion: @escaping GetTokenCompletion) -> DataRequest {
        let request = Router.getAccessToken(client_id: client_id, redirect_uri: redirect_uri, client_secret: client_secret, code: code)
        return service.request(request)
            .validate(statusCode: validCodes)
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
    
    @discardableResult
    func inspect(token: String, appAccessToken: String, completion: @escaping InspectTokenCompletion) -> DataRequest {
        let request = Router.inspectToken(token: token, appAccessToken: appAccessToken)
        return service.request(request)
            .validate(statusCode: validCodes)
            .responseJSON(completionHandler: { (response) in
                var isValid: Bool? = false
                var userID: String?
                
                switch response.result {
                case .success(let JSON):
                    if let responseData = (JSON as? [String : Any])?["data"] as? [String : Any]{
                        userID = responseData["user_id"] as? String
                        isValid = responseData["is_valid"] as? Bool
                    }
                case .failure:
                    break;
                }
                completion(userID, isValid)
            })
    }
}


    
    


















