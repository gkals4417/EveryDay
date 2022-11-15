//
//  EveryDayManager.swift
//  EveryDay
//
//  Created by Hamin Jeong on 2022/11/09.
//

import UIKit
import CoreData

final class EveryDayManager {
    
    private let coreDataManager = CoreDataManager.shared
    
    static let shared = EveryDayManager()
    
    var coreDataArray: [CoreData] = []
    
    private init(){
        coreDataArray = coreDataManager.readCoreData()
        print(coreDataArray)
    }
    
    func getCoreDataArray() -> [CoreData]{
        return coreDataArray
    }
    
    func saveCoreData(word: String, meaning: String, memo: String, completion: @escaping () -> Void){
        coreDataManager.saveCoreData(word: word, meaning: meaning, memo: memo) {
            completion()
        }
        print("\(#function) : CoreData Saved")
        self.coreDataArray = self.coreDataManager.readCoreData()
    }
    
    func updateCoreData(newCoreData: CoreData, completion: @escaping () -> Void){
        coreDataManager.updateCoreData(newCoreData: newCoreData) {
            completion()
        }
        print("\(#function) : CoreData Updated")
        self.coreDataArray = self.coreDataManager.readCoreData()
    }
    
    func deleteCoreData(targetData: CoreData, completion: @escaping () -> Void){
        coreDataManager.deleteCoreData(data: targetData) {
            completion()
        }
        print("\(#function) : CoreData Deleted")
        self.coreDataArray = self.coreDataManager.readCoreData()
    }
    
}
