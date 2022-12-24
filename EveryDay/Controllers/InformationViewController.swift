//
//  InformationViewController.swift
//  EveryDay
//
//  Created by Hamin Jeong on 2022/12/06.
//

import UIKit
import HGCircularSlider

final class InformationViewController: UIViewController {

    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var developerImageView: UIImageView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var fourthView: UIView!
    @IBOutlet weak var progress: CircularSlider!
    @IBOutlet weak var developerLabel: UILabel!

    let appManager = EveryDayManager.shared
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    var receivedArray: [Int] = [] {
        didSet {
            print("receivedArray \(receivedArray)")
        }
    }
    private var savedCoreArray: [CoreData] = [] {
        didSet {
            print("Info ViewController savedCoreArray changed \n \(savedCoreArray)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialFunc()
        appearanceFunc()
        setupGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initialFunc()
    }
    
    private func initialFunc() {
        developerImageView.image = UIImage(named: "myCharacter.png")
        savedCoreArray = appManager.getCoreDataArray()
        rateLabel.font = UIFont(name: "BMHANNAPro", size: 20)
        rateLabel.textColor = .black
        totalCountLabel.textColor = .white
        totalCountLabel.text = "\(savedCoreArray.count) 개 단어 저장됨"
        rateLogicFunc()
    }
    
    private func rateLogicFunc() {
        guard let temp = appManager.delegate?.getInfo() else { return }
        receivedArray = temp
        
        if savedCoreArray.count == 0 {
            rateLabel.text = "저장된 단어가 없습니다."
//            rateLabel.font = UIFont(name: "BMHANNAPro", size: 15)
            progress.endPointValue = 0.0
        } else {
            let percent = 100 * (Double(receivedArray[0]) / (Double(receivedArray[0] + receivedArray[1])))
            let roundPercent = round(percent*10)/10
            
            if receivedArray[0] + receivedArray[1] == 0 {
                rateLabel.text = "문제를 푸세요."
//                rateLabel.font = UIFont(name: "BMHANNAPro", size: 15)
            } else {
                rateLabel.text = "\(String(roundPercent)) %"
            }
            progress.endPointValue = CGFloat(roundPercent)
        }
    }
    
    private func appearanceFunc() {
        progress.layer.backgroundColor = Constants.customCGLightGrayColor
        progress.layer.cornerRadius = 12
        progress.layer.masksToBounds = true
        progress.layer.borderWidth = 0.2
        progress.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        secondView.layer.backgroundColor = Constants.customCGBlueColor
        secondView.layer.cornerRadius = 12
        secondView.layer.masksToBounds = true
        secondView.layer.borderWidth = 0.2
        secondView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        thirdView.layer.backgroundColor = Constants.customCGBlueColor
        thirdView.layer.cornerRadius = 12
        thirdView.layer.masksToBounds = true
        thirdView.layer.borderWidth = 0.2
        thirdView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
//        fourthView.layer.backgroundColor = CGColor(red: 78/255, green: 120/255, blue: 246/255, alpha: 1.0)
        fourthView.layer.cornerRadius = 12
        fourthView.layer.masksToBounds = true
        fourthView.layer.borderWidth = 0.2
        fourthView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        progress.backgroundColor = .clear
        progress.diskColor = .clear
        progress.trackColor = .clear
        progress.trackFillColor = Constants.customBlueColor
        progress.backtrackLineWidth = 20
        progress.lineWidth = 20
        progress.thumbRadius = 10
        progress.thumbLineWidth = 0
        progress.endThumbTintColor = .clear
        progress.minimumValue = 0
        progress.maximumValue = 100
//        progress.diskFillColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 0.5)
        progress.isUserInteractionEnabled = false
        progress.endPointValue = 0.3
        
        totalCountLabel.font = UIFont(name: "BMHANNAPro", size: 20)
        developerLabel.font = UIFont(name: "BMHANNAAir", size: 20)
        developerLabel.textAlignment = .center
        developerLabel.text = "개발자 정보"
    }
    
    func setupGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(touchUpImageView))
        developerImageView.addGestureRecognizer(gesture)
        developerImageView.isUserInteractionEnabled = true
    }
    
    @objc func touchUpImageView() {
        print("이미지터치됨")
        let alert = UIAlertController(title: "Made by Pulsar", message: "gkals4417@icloud.com", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}


