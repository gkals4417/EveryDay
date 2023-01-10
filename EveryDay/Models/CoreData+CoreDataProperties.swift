//
//  CoreData+CoreDataProperties.swift
//  EveryDay
//
//  Created by Hamin Jeong on 2023/01/10.
//
//

import Foundation
import CoreData


extension CoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreData> {
        return NSFetchRequest<CoreData>(entityName: "CoreData")
    }

    @NSManaged public var quizCorrect: Double
    @NSManaged public var quizIncorrect: Double
    @NSManaged public var savedDate: Date?
    @NSManaged public var savedDetailMemo: String?
    @NSManaged public var savedMeaning: String?
    @NSManaged public var savedWord: String?
    @NSManaged public var wordClass: [String]?

}

extension CoreData : Identifiable {

}
