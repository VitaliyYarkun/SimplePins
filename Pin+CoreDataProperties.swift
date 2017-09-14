//
//  Pin+CoreDataProperties.swift
//  vitaliy_yarkun_SimplePins
//
//  Created by Vitaliy Yarkun on 9/14/17.
//  Copyright © 2017 Vitaliy Yarkun. All rights reserved.
//

import Foundation
import CoreData


extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var user: User?

}
