//
//  InformationViewController.swift
//  EveryDay
//
//  Created by Hamin Jeong on 2022/12/06.
//

import UIKit
import HGCircularSlider
class InformationViewController: UIViewController {

    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var fourthView: UIView!
    @IBOutlet weak var progress: CircularSlider!
    
    let appManager = EveryDayManager.shared
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    var receivedArray: [Int] = [] {
        didSet {
            print("receivedArray \(receivedArray)")
        }
    }
    let menuArray = ["총 단어 갯수", "문제 평점", "제작 정보", "아이콘"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialFunc()
        appearanceFunc()
        view.backgroundColor = .white
    }
    
    private func initialFunc() {
        guard let temp = appManager.delegate?.getInfo() else { return }
        receivedArray = temp
    }
    
    private func appearanceFunc() {
        progress.layer.backgroundColor = CGColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 0.5)
        progress.layer.cornerRadius = 12
        progress.layer.masksToBounds = true
        progress.layer.borderWidth = 0
        progress.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        secondView.layer.backgroundColor = CGColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 0.5)
        secondView.layer.cornerRadius = 12
        secondView.layer.masksToBounds = true
        secondView.layer.borderWidth = 0.2
        secondView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        thirdView.layer.backgroundColor = CGColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 0.5)
        thirdView.layer.cornerRadius = 12
        thirdView.layer.masksToBounds = true
        thirdView.layer.borderWidth = 0.2
        thirdView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        fourthView.layer.backgroundColor = CGColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 0.5)
        fourthView.layer.cornerRadius = 12
        fourthView.layer.masksToBounds = true
        fourthView.layer.borderWidth = 0.2
        fourthView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        progress.backgroundColor = .clear
        progress.diskColor = .clear
        progress.trackColor = .clear
        progress.trackFillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        progress.backtrackLineWidth = 20
        progress.lineWidth = 20
        progress.thumbRadius = 10
        progress.thumbLineWidth = 0
        progress.endThumbTintColor = .clear
        progress.minimumValue = 0
        progress.maximumValue = 1
//        progress.diskFillColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 0.5)
        progress.isUserInteractionEnabled = false
        progress.endPointValue = 0.5
    }
    
}


