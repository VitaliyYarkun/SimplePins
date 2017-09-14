//
//  CurrentUser.swift
//  vitaliy_yarkun_SimplePins
//
//  Created by Vitaliy Yarkun on 9/13/17.
//  Copyright © 2017 Vitaliy Yarkun. All rights reserved.
//

import CoreData

final class CurrentUser{
    
    //MARK: - Properties
    static var token: String? {
        get {
            return LocalStore().accessToken
        }
        set {
            LocalStore().accessToken = newValue!
        }
    }
    
    private lazy var managedContext:NSManagedObjectContext = {
        return DatabaseController.getContext()
    }()
}
