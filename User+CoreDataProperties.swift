//
//  User+CoreDataProperties.swift
//  vitaliy_yarkun_SimplePins
//
//  Created by Vitaliy Yarkun on 9/14/17.
//  Copyright © 2017 Vitaliy Yarkun. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var accessToken: String?
    @NSManaged public var userID: String?
    @NSManaged public var pins: NSSet?

}

// MARK: Generated accessors for pins
extension User {

    @objc(addPinsObject:)
    @NSManaged public func addToPins(_ value: Pin)

    @objc(removePinsObject:)
    @NSManaged public func removeFromPins(_ value: Pin)

    @objc(addPins:)
    @NSManaged public func addToPins(_ values: NSSet)

    @objc(removePins:)
    @NSManaged public func removeFromPins(_ values: NSSet)

}
