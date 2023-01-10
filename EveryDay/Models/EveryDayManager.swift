//
//  EveryDayManager.swift
//  EveryDay
//
//  Created by Hamin Jeong on 2022/11/09.
//

import UIKit
import CoreData

protocol QuizInfoDelegate: AnyObject {
    func getInfo() -> [Int]
    func getQuizCorrectData() -> [String]
    func getQuizIncorrectData() -> [String]
}

protocol RefreshDelegate: AnyObject {
    func refreshTableView()
    func refreshCalendar()
}

final class EveryDayManager {
    
    private let coreDataManager = CoreDataManager.shared
    
    static let shared = EveryDayManager()
    
    var coreDataArray: [CoreData] = []
    
    var delegate: QuizInfoDelegate?
    var refreshDelegate: RefreshDelegate?
    
    private init(){
        coreDataArray = coreDataManager.readCoreData()
        print(coreDataArray)
    }
    
    func getCoreDataArray() -> [CoreData]{
        print(#function)
        return coreDataArray
    }
    
    func saveCoreData(word: String, meaning: String, memo: String, wordClass: [String], completion: @escaping () -> Void) {
        coreDataManager.saveCoreData(word: word, meaning: meaning, memo: memo, wordClass: wordClass) {
            completion()
            self.coreDataArray = self.coreDataManager.readCoreData()
        }
        print("\(#function) : CoreData Saved")
        
    }
    
    func saveQuizCoreData(correct: Double, incorrect: Double, completion: @escaping () -> Void) {
        coreDataManager.saveQuizCoreData(correct: correct, incorrect: incorrect) {
            completion()
            self.coreDataArray = self.coreDataManager.readCoreData()
        }
        print("\(#function) : QuizCoreData Saved")
    }
    
    func updateCoreData(newCoreData: CoreData, completion: @escaping () -> Void) {
        coreDataManager.updateCoreData(newCoreData: newCoreData) {
            completion()
            self.coreDataArray = self.coreDataManager.readCoreData()
        }
        print("\(#function) : CoreData Updated")
        
    }
    
    func deleteCoreData(targetData: CoreData, completion: @escaping () -> Void) {
        coreDataManager.deleteCoreData(data: targetData) {
            completion()
            self.coreDataArray = self.coreDataManager.readCoreData()
        }
        print("\(#function) : CoreData Deleted")
        
    }
    
}
