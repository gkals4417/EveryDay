//
//  InformationViewController.swift
//  EveryDay
//
//  Created by Hamin Jeong on 2022/12/06.
//

import UIKit

class InformationViewController: UIViewController {

    let appManager = EveryDayManager.shared

    var receivedArray: [Int] = [] {
        didSet {
            print("receivedArray \(receivedArray)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let temp = appManager.delegate?.getInfo() else { return }
        receivedArray = temp
    }
    
}
