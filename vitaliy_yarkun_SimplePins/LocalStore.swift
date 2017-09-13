//
//  LocalStore.swift
//  vitaliy_yarkun_SimplePins
//
//  Created by Vitaliy Yarkun on 9/13/17.
//  Copyright © 2017 Vitaliy Yarkun. All rights reserved.
//
import Foundation

class LocalStore {
    
    //MARK: - Constans
    private struct Constans {
        struct Keys {
            static let loginCode = "VY.LocalStore.loginCode"
            static let accessToken = "VY.LocalStore.accessToken"
        }
    }
    
    var loginCode: String {
        get {
            return UserDefaults.standard.string(forKey: Constans.Keys.loginCode) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constans.Keys.loginCode)
            UserDefaults.standard.synchronize()
        }
    }
    
    var accessToken: String {
        get {
            return UserDefaults.standard.string(forKey: Constans.Keys.accessToken) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constans.Keys.accessToken)
            UserDefaults.standard.synchronize()
        }
    }
}
