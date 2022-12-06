//
//  CoreDataManager.swift
//  EveryDay
//
//  Created by Hamin Jeong on 2022/11/09.
//

import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init(){}
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    private lazy var context = appDelegate?.persistentContainer.viewContext
    
    private let modelName: String = "CoreData"
    
    // MARK: - READ
    
    func readCoreData() -> [CoreData]{
        var array: [CoreData] = []
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            let dataOrder = NSSortDescriptor(key: "savedDate", ascending: false)
            request.sortDescriptors = [dataOrder]
            
            do {
                if let fetched = try context.fetch(request) as? [CoreData]{
                    array = fetched
                }
            } catch {
                print("Failed fetch")
            }
        }
        
        return array
    }
    
    // MARK: - SAVE
    
    func saveCoreData(word: String, meaning: String, memo: String, completion: @escaping () -> Void) {
        if let context = context {
            if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
                if let coreData = NSManagedObject(entity: entity, insertInto: context) as? CoreData {
                    coreData.savedWord = word
                    coreData.savedMeaning = meaning
                    coreData.savedDate = Date()
                    coreData.savedDetailMemo = memo
                    
                    if context.hasChanges {
                        do {
                            try context.save()
                            completion()
                        } catch {
                            print(error)
                            completion()
                        }
                    }
                }
            }
        }
        completion()
    }


    // MARK: - DELETE
    
    func deleteCoreData(data: CoreData, completion: @escaping () -> Void) {
        guard let date = data.savedDate else {
            completion()
            return
        }
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            request.predicate = NSPredicate(format: "savedDate = %@", date as CVarArg)
            
            do {
                if let fetched = try context.fetch(request) as? [CoreData] {
                    if let target = fetched.first {
                        context.delete(target)
                        if context.hasChanges {
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print(error)
                                completion()
                            }
                        }
                    }
                }
                completion()
            } catch {
                print("Failed Delete")
                completion()
            }
        }
    }

    // MARK: - UPDATE
    
    func updateCoreData(newCoreData: CoreData, completion: @escaping () -> Void) {
        guard let date = newCoreData.savedDate else {
            completion()
            return
        }
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            request.predicate = NSPredicate(format: "savedDate = %@", date as CVarArg)
            do {
                if let fetched = try context.fetch(request) as? [CoreData] {
                    if var target = fetched.first {
                        target = newCoreData
                        
                        if context.hasChanges {
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print(error)
                                completion()
                            }
                        }
                    }
                }
                completion()
            } catch {
                print("Failed Update")
                completion()
            }
        }
    }
}
