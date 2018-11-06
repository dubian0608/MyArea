//
//  Areas+CoreDataProperties.swift
//  MyArea
//
//  Created by Zhang, Frank on 21/04/2017.
//  Copyright © 2017 Zhang, Frank. All rights reserved.
//

import Foundation
import CoreData


extension Areas {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Areas> {
        return NSFetchRequest<Areas>(entityName: "Areas")
    }

    @NSManaged public var name: String?
    @NSManaged public var isVisted: Bool
    @NSManaged public var province: String?
    @NSManaged public var part: String?
    @NSManaged public var image: NSData?
    @NSManaged public var rating: NSData?

}
