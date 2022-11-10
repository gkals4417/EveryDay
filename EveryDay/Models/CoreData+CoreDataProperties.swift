//
//  CoreData+CoreDataProperties.swift
//  EveryDay
//
//  Created by Hamin Jeong on 2022/11/09.
//
//

import Foundation
import CoreData


extension CoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreData> {
        return NSFetchRequest<CoreData>(entityName: "CoreData")
    }

    @NSManaged public var savedWord: String?
    @NSManaged public var savedMeaning: String?
    @NSManaged public var savedDate: Date?

}

extension CoreData : Identifiable {

}
