//
//  QuizViewController.swift
//  EveryDay
//
//  Created by Hamin Jeong on 2022/12/06.
//

import UIKit

class QuizViewController: UIViewController {

    private let appManager = EveryDayManager.shared
    private var savedCoreArray: [CoreData] = []{
        didSet {
            print("Quiz ViewController savedCoreArray changed \n \(savedCoreArray)")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialFunc()
        appearanceFunc()
    }

    private func initialFunc() {
        savedCoreArray = appManager.getCoreDataArray()
    }
    
    private func appearanceFunc() {
        view.backgroundColor = .white
        
    }
    
    
}
