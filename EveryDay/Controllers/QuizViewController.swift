//
//  QuizViewController.swift
//  EveryDay
//
//  Created by Hamin Jeong on 2022/12/06.
//

import UIKit
import HGCircularSlider
import AVFoundation

class QuizViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var progress: CircularSlider!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    private let appManager = EveryDayManager.shared
    private var savedCoreArray: [CoreData] = []{
        didSet {
            print("Quiz ViewController savedCoreArray changed \n \(savedCoreArray)")
        }
    }
    
    var timer: Timer?
    var isPaused: Bool = false
    var currentTime: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification: )), name: UIResponder.keyboardWillHideNotification, object: nil)
        progress.addTarget(self, action: #selector(updateProgressUI), for: .valueChanged)
        
        initialFunc()
        appearanceFunc()
    }

    private func initialFunc() {
        answerTextField.delegate = self
        savedCoreArray = appManager.getCoreDataArray()
    }
    
    private func appearanceFunc() {
        view.backgroundColor = .white
        
        progress.backgroundColor = .clear
        progress.diskColor = .clear
        progress.trackColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 0.5)
        progress.trackFillColor = .black
        progress.backtrackLineWidth = 2
        progress.thumbRadius = 9
        progress.thumbLineWidth = 0
        progress.endThumbTintColor = .black
        progress.minimumValue = 0
        progress.maximumValue = 300
        
        answerTextField.placeholder = "뜻을 입력하세요."
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            view.frame.origin.y -= keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            view.frame.origin.y += keyboardSize.height
        }
    }
    
    @objc func updateProgressUI() {
        let value = progress.endPointValue
        let intValue = Int(value)
        timeLabel.text = String(describing: intValue)
        currentTime = intValue
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        startTimer()
    }
    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        pauseTimer()
    }
    
    @objc func updateTimer(){
        if 0 < currentTime {
            currentTime -= 1
            timeLabel.text = String(describing: currentTime)
            progress.endPointValue = CGFloat(currentTime)
        } else {
            timer?.invalidate()
            currentTime = 0
            timeLabel.text = "끝났습니다!"
            AudioServicesPlaySystemSound(1102)
        }
    }

    func startTimer(){
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
    }

    func pauseTimer(){
        if isPaused {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            isPaused = false
        } else {
            timer?.invalidate()
            isPaused = true
        }
    }
}


extension QuizViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        answerTextField.text = ""
        view.endEditing(true)
        return true
    }
}
