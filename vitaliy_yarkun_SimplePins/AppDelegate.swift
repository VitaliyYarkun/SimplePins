//
//  AppDelegate.swift
//  vitaliy_yarkun_SimplePins
//
//  Created by Vitaliy Yarkun on 9/12/17.
//  Copyright © 2017 Vitaliy Yarkun. All rights reserved.
//

import UIKit
import CoreData

struct Global {
    static var facebookClientID = "1660470584023500"
    static var facebookRedirectURI = "fb1660470584023500://authorize/"
    static var facebookClientSecret = "0b09d03d3583e666733c5eda5c51dfbb"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }
}
