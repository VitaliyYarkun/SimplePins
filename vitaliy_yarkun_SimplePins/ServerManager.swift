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


    
    


















