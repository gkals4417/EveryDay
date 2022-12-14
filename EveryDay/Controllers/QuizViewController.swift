//
//  QuizViewController.swift
//  EveryDay
//
//  Created by Hamin Jeong on 2022/12/06.
//

import UIKit
import HGCircularSlider
import AVFoundation

final class QuizViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var progress: CircularSlider!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!

    private let appManager = EveryDayManager.shared
    private var savedCoreArray: [CoreData] = [] {
        didSet {
            print("Quiz ViewController savedCoreArray changed \n \(savedCoreArray)")
        }
    }
    private var tempArray: [CoreData] = [] {
        didSet {
            print("Randomized Temp Array Chanded \n \(tempArray)")
        }
    }
    private var tempArrayMaxIndex: Int = 0
    private var correctCount: Int = 0 {
        didSet {
            print("답을 맞췄습니다. : \(correctCount)")
        }
    }
    private var incorrectCount: Int = 0 {
        didSet {
            print("답이 틀렸습니다. : \(incorrectCount)")
        }
    }
    private var correctWord: [String] = []
    private var incorrectWord: [String] = []
    
    private var timer: Timer?
    private var isPaused: Bool = false
    private var currentTime: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        savedCoreArray = appManager.getCoreDataArray()
    }
    
    override func viewDidLoad() {
        appManager.delegate = self
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
        answerTextField.isEnabled = false
        timeLabel.textColor = Constants.customGrayColor
    }
    
    private func appearanceFunc() {
        view.backgroundColor = .white
        
        DispatchQueue.main.async {
//            self.startButton.titleLabel?.font = UIFont(name: "BMHANNAPro", size: 15)
//            self.pauseButton.titleLabel?.font = UIFont(name: "BMHANNAPro", size: 15)
            self.questionLabel.font = UIFont(name: "BMHANNAPro", size: 15)
            self.timeLabel.font = UIFont(name: "BMHANNAPro", size: 20)
            self.answerTextField.font = UIFont(name: "BMHANNAPro", size: 15)
        }
        
        startButton.setTitle("시작", for: .normal)
        startButton.setTitleColor(.black, for: .normal)
        startButton.setTitleColor(Constants.customBlueColor, for: .highlighted)
        pauseButton.setTitle("일시정지", for: .normal)
        pauseButton.setTitleColor(.black, for: .normal)
        pauseButton.setTitleColor(Constants.customBlueColor, for: .highlighted)
        
        progress.backgroundColor = .clear
        progress.diskColor = .clear
        progress.trackColor = Constants.customLightGrayColor
        progress.trackFillColor = Constants.customBlueColor
        progress.backtrackLineWidth = 2
        progress.thumbRadius = 6
        progress.thumbLineWidth = 0
        progress.endThumbTintColor = Constants.customBlueColor
        progress.minimumValue = 0
        progress.maximumValue = 300
        progress.diskFillColor = Constants.customLightGrayColor
        
        timeLabel.text = "원하는 시간(초)를 선택하세요."
        answerTextField.backgroundColor = Constants.customLightGrayColor
        answerTextField.layer.borderWidth = 0.1
        answerTextField.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
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
        timeLabel.text = "\(String(describing: intValue)) 초"
        currentTime = intValue
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        startTimer()
    }
    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        pauseTimer()
    }
    
    @objc func updateTimer() {
        if 0 < currentTime {
            currentTime -= 1
            timeLabel.text = "\(String(describing: currentTime)) 초"
            progress.endPointValue = CGFloat(currentTime)
            startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            startButton.setTitle("진행중", for: .normal)
        } else {
            timer?.invalidate()
            currentTime = 0
            timeLabel.text = "끝났습니다!"
            startButton.setTitle("시작", for: .normal)
            startButton.setImage(UIImage(), for: .normal)
            answerTextField.isEnabled = false
            AudioServicesPlaySystemSound(1102)
        }
    }

    func startTimer() {
        
        if savedCoreArray.isEmpty {
            timeLabel.text = "저장된 단어가 없습니다."
            progress.endPointValue = 0.0
            answerTextField.isEnabled = false
        } else {
            correctCount = 0
            incorrectCount = 0
            tempArray = savedCoreArray.shuffled()
            tempArrayMaxIndex = tempArray.count - 1
            questionLabel.text = tempArray[tempArrayMaxIndex].savedWord
            answerTextField.isEnabled = true
            
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
        
        
        
    }

    func pauseTimer() {
        if isPaused {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            isPaused = false
            pauseButton.setTitle("일시정지", for: .normal)
        } else {
            timer?.invalidate()
            isPaused = true
            pauseButton.setTitle("다시시작", for: .normal)
        }
    }
    
}


extension QuizViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if tempArrayMaxIndex > 0 {
            guard let answer = answerTextField.text else { return false }
            if answer == tempArray[tempArrayMaxIndex].savedMeaning {
                correctCount += 1
                correctWord.append(answer)
            } else {
                incorrectCount += 1
                incorrectWord.append(answer)
            }
            tempArrayMaxIndex -= 1
            questionLabel.text = tempArray[tempArrayMaxIndex].savedWord
            
        } else {
            questionLabel.text = tempArray[tempArrayMaxIndex].savedWord
            guard let answer = answerTextField.text else { return false }
            if answer == tempArray[tempArrayMaxIndex].savedMeaning {
                correctCount += 1
                correctWord.append(answer)
            } else {
                incorrectCount += 1
                incorrectWord.append(answer)
            }
            
            questionLabel.text = "맞춘 갯수 : \(correctCount),    틀린 갯수 : \(incorrectCount)"
            tempArrayMaxIndex = tempArray.count - 1
            answerTextField.isEnabled = false
            timeLabel.text = "문제종료"
            AudioServicesPlaySystemSound(4095)
            timer?.invalidate()
        }
        
        answerTextField.text = ""
        return true
    }
    
}

extension QuizViewController: QuizInfoDelegate {
    func getInfo() -> [Int] {
        print(#function)
        var array: [Int] = []
        array.append(correctCount)
        array.append(incorrectCount)
        return array
    }
    
    func getQuizCorrectData() -> [String] {
        return correctWord
    }
    
    func getQuizIncorrectData() -> [String] {
        return incorrectWord
    }
}
