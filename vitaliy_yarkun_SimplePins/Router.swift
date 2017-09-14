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
    case getAccessToken(client_id: String, redirect_uri: String, client_secret: String, code: String)
    case inspectToken(token: String, appAccessToken: String)
    
    //MARK: - Base URL
    private var baseURLString: String {
        switch self {
        case .login:
            return "https://www.facebook.com"
        case .getAccessToken, .inspectToken:
            return "https://graph.facebook.com"
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
            return "/v2.10/dialog/oauth?client_id=\(client_id)&display=\(loginDisplayType)&response_type=\(loginResponseType)&redirect_uri=\(redirect_uri)"
        
        case .getAccessToken(let client_id, let redirect_uri, let client_secret, let code):
            return "/v2.10/oauth/access_token?client_id=\(client_id)&redirect_uri=\(redirect_uri)&client_secret=\(client_secret)&code=\(code)"
        
        case .inspectToken(let token, let appAccessToken):
            return "/debug_token?input_token=\(token)&access_token=\(appAccessToken)".addingPercentEscapes(using: .utf8)!
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try self.baseURLString.appending(path).asURL()
        var urlRequest = URLRequest(url: url)
        
        switch self {
        case .getAccessToken, .inspectToken:
            urlRequest.httpMethod = self.method.rawValue
        default:
            break
        }
        return urlRequest
    }
}
