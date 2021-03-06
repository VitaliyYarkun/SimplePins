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
    
    //MARK: - IBOutlet
    @IBOutlet weak var loginOutlet: UIButton!
    
    //MARK: - Properties
    fileprivate lazy var managedContext:NSManagedObjectContext = {
        return DatabaseController.getContext()
    }()
    
    //MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginOutlet.layer.borderWidth = 2
        loginOutlet.layer.borderColor = UIColor.white.cgColor
        loginOutlet.layer.cornerRadius = 10
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
