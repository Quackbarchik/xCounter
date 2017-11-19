//
//  Counter+CoreDataProperties.swift
//  xCounter
//
//  Created by Zakhar Rudenko on 02.11.2017.
//  Copyright © 2017 Zakhar Rudenko. All rights reserved.
//
//

import Foundation
import CoreData


extension Counter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Counter> {
        return NSFetchRequest<Counter>(entityName: "Counter")
    }

    @NSManaged public var count: String?
    @NSManaged public var createdAt: Double
    @NSManaged public var name: String?

}
