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
    
    typealias LoginCompletion = (_ success: Bool) -> Void
    
    lazy var service: ServiceProtocol = AlamofireService()
    
}

//extension ServerManager {
//    
//    fileprivate enum Router: URLRequestConvertible {
//        
//        //MARK: - Router case
//        case login
//        
//        //MARK: - Base URL
//        private var baseURLString: String {
//            return "https://graph.facebook.com/"
//        }
//        
//        //MARK: - HTTP Method
//        private var method: HTTPMethod {
//            
//            switch self {
//            case .login:
//                return .get
//            }
//        }
//        
//        //MARK: - Path
//        private var path: String {
//            switch self {
//            case .login:
//                return "v2.10/oauth/access_token"
//            }
//        }
//        
////        //MARK: - Content type
////        private var contentType: String {
////            return "application/json"
////        }
//        
//        //MARK: - Headers
//        private func addHeaders(for request: inout URLRequest) {
//            
//            request.setValue("", forHTTPHeaderField: <#T##String#>)
//        }
//    }
//}


















