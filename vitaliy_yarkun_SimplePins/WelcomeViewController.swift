//
//  WelcomeViewController.swift
//  vitaliy_yarkun_SimplePins
//
//  Created by Vitaliy Yarkun on 9/13/17.
//  Copyright © 2017 Vitaliy Yarkun. All rights reserved.
//

import UIKit
import CoreData

final class WelcomeViewController: UIViewController {
    
    fileprivate lazy var managedContext:NSManagedObjectContext = {
        return DatabaseController.getContext()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userFetch: NSFetchRequest<User> = User.fetchRequest()
        do {
            let results = try managedContext.fetch(userFetch)
            if results.count > 0 {
                let user = results.first
                let lVC = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                lVC.userID = user?.userID
                self.navigationController?.pushViewController(lVC, animated: true)
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }

    }
    
}
