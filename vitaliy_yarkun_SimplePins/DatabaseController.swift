//
//  DatabaseController.swift
//  vitaliy_yarkun_SimplePins
//
//  Created by Vitaliy Yarkun on 9/13/17.
//  Copyright © 2017 Vitaliy Yarkun. All rights reserved.
//

import Foundation
import CoreData

final class DatabaseController {
    
    //MARK: - Init
    private init() {
        
    }
    
    //MARK: - Methods
    class func getContext () -> NSManagedObjectContext {
        return DatabaseController.managedObjectContext
    }
    
    //MARK: - Core Data stack
    static var managedObjectContext: NSManagedObjectContext = {
        
        var applicationDocumentsDirectory: URL = {
            
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return urls[urls.count-1]
        }()
        
        var managedObjectModel: NSManagedObjectModel = {
            
            let modelURL = Bundle.main.url(forResource: "vitaliy_yarkun_SimplePins", withExtension: "momd")!
            return NSManagedObjectModel(contentsOf: modelURL)!
        }()
        
        var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
            
            let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
            let url = applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
            var failureReason = "There was an error creating or loading the application's saved data."
            do {
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
            } catch {
                
                var dict = [String: AnyObject]()
                dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
                dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
                
                dict[NSUnderlyingErrorKey] = error as NSError
                let wrappedError = NSError(domain: "com.vitaliyyarkun.vitaliy-yarkun-SimplePins.ErrorDomain", code: 9999, userInfo: dict)
                
                NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
                abort()
            }
            
            return coordinator
        }()
        
        let coordinator = persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    class func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                
                let error = error as NSError
                NSLog("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
        }
    }
}
