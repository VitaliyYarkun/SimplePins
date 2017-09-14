//
//  MapViewController.swift
//  vitaliy_yarkun_SimplePins
//
//  Created by Vitaliy Yarkun on 9/13/17.
//  Copyright © 2017 Vitaliy Yarkun. All rights reserved.
//

import UIKit
import CoreData

class MapViewController: UIViewController {
    
    //MARK: - Properties
    private lazy var managedContext:NSManagedObjectContext = {
        return DatabaseController.getContext()
    }()
    var currentUser: User?
    var token: String!
    var userID: String!
    
    
    //MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUser()
    }
    
    func loadUser() {
        let userEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)
        
        let userFetch: NSFetchRequest<User> = User.fetchRequest()
        userFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(User.userID), userID)
        
        do {
            let results = try managedContext.fetch(userFetch)
            if results.count > 0 {
                let user = results.first
                user?.accessToken = token
                currentUser = user
                try managedContext.save()
            } else {
                let user = User(entity: userEntity!, insertInto: managedContext)
                user.userID = userID
                user.accessToken = token
                currentUser = user
                try managedContext.save()
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
}
