//
//  Router.swift
//  vitaliy_yarkun_SimplePins
//
//  Created by Vitaliy Yarkun on 9/13/17.
//  Copyright © 2017 Vitaliy Yarkun. All rights reserved.
//

import Alamofire

enum Router: URLRequestConvertible {
    //MARK: - Properties
    
    private var loginDisplayType: String {
        return "touch"
    }
    
    private var loginResponseType: String {
        return "code"
    }
    
    //MARK: - Router case
    case login(client_id: String, redirect_uri: String)
    
    //MARK: - Base URL
    private var baseURLString: String {
        switch self {
        case .login:
            return "https://www.facebook.com/v2.10"
        default:
            return "https://graph.facebook.com/"
        }
    }
    
    //MARK: - HTTP Method
    private var method: HTTPMethod {
        return .get
    }
    
    //MARK: - Path
    private var path: String {
        switch self {
        case .login(let client_id, let redirect_uri):
            return "/dialog/oauth?client_id=\(client_id)&display=\(loginDisplayType)&response_type=\(loginResponseType)&redirect_uri=\(redirect_uri)"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try self.baseURLString.appending(path).asURL()
        let urlRequest = URLRequest(url: url)
        
        return urlRequest
    }
}
