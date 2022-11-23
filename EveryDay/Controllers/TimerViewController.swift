//
//  TimerViewController.swift
//  EveryDay
//
//  Created by Hamin Jeong on 2022/11/18.
//

import UIKit

class TimerViewController: UIViewController {

    @IBOutlet weak var countProblemLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var puaseButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    private let appManager = EveryDayManager.shared
    var tempArray: [CoreData] = []{
        didSet {
            print("Timer VC Temp Array : \(tempArray)")
        }
    }
    private var randomizedArray: [CoreData] = []
    private var tempNumber: Int = 0
    
    private var timer: Timer?
    var totalTime: Float = 180
    var passedTime: Float = 0.0
    var isPaused: Bool = false
    
    var randomizedCount: Int = 0
    var correctCount: Int = 0
    var failedCount: Int = 0
    var tempCorrectCount: Int = 0
    var tempFailedCount: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answerTextField.delegate = self
        tempArray = appManager.getCoreDataArray()
        progressUI()
        labelUI()
        randomizedArray = tempArray.shuffled()
        
    }
    
    func progressUI(){
        progressView.progress = 0.5
        progressView.progressViewStyle = .bar
        progressView.progressTintColor = .red
        progressView.trackTintColor = .lightGray
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 5)
    }
    
    func labelUI(){
        countProblemLabel.text = ""
        timeLabel.text = "시작하려면 버튼을 누르세요."
    }
    
    @objc func updateTimer(){
        if passedTime < totalTime {
            let percentageProgress = passedTime / totalTime
            progressView.progress = percentageProgress
            passedTime += 1
            timeLabel.text = "\(String(format: "%.0f", 120 - passedTime)) 초 남았습니다."
        } else {
            timer?.invalidate()
            progressView.progress = 1.0
            passedTime = 0
            questionLabel.text = "끝났습니다."
        }
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        timer?.invalidate()
        progressView.progress = 0.0
        passedTime = 0.0
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        tempCorrectCount = 0
        tempFailedCount = 0
        
        randomizedCount = randomizedArray.count - 1
        countProblemLabel.text = " 0 / \(randomizedArray.count)"
        questionLabel.text = randomizedArray.last?.savedWord
        
    }
    
    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        if isPaused {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            isPaused = false
        } else {
            timer?.invalidate()
            isPaused = true
        }
    }
}


extension TimerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField.text == randomizedArray[randomizedCount].savedMeaning{
            tempCorrectCount += 1
            randomizedCount -= 1
            textField.text = ""
            
            if randomizedCount < 0 {
                timer?.invalidate()
                progressView.progress = 1.0
                passedTime = 0
                timeLabel.text = "모든 문제가 끝났습니다."
                questionLabel.text = ""
            } else {
                questionLabel.text = randomizedArray[randomizedCount].savedWord
            }
            print("정답 : \(tempCorrectCount)")
        } else {
            tempFailedCount += 1
            randomizedCount -= 1
            textField.text = ""
            if randomizedCount < 0 {
                timer?.invalidate()
                progressView.progress = 1.0
                passedTime = 0
                timeLabel.text = "모든 문제가 끝났습니다."
                questionLabel.text = ""
            } else {
                questionLabel.text = randomizedArray[randomizedCount].savedWord
            }
            print("오답 : \(tempFailedCount)")
        }
        correctCount = tempCorrectCount
        failedCount = tempFailedCount
        
        
        print("최종 정답 갯수 : \(correctCount)")
        print("최종 오답 갯수 : \(failedCount)")
        return true
    }
}
