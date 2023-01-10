//
//  SaveViewController.swift
//  EveryDay
//
//  Created by Hamin Jeong on 2023/01/08.
//

import UIKit

class SaveViewController: UIViewController {

    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var meaningTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nounButton: UIButton!
    @IBOutlet weak var pronounButton: UIButton!
    @IBOutlet weak var adjectiveButton: UIButton!
    @IBOutlet weak var verbButton: UIButton!
    @IBOutlet weak var adverbButton: UIButton!
    @IBOutlet weak var prepositionButton: UIButton!
    @IBOutlet weak var conjunctionButton: UIButton!
    @IBOutlet weak var interjectionButton: UIButton!
    @IBOutlet weak var memoTextField: UITextField!
    
    private var tempWordClass: [String] = []
    
    let appManager = EveryDayManager.shared
    
    private var savedCoreArray: [CoreData] = [] {
        didSet {
            print("savedCoreArray Changed \n \(savedCoreArray)")
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialFunc()
        appearenceFunc()
        
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        appManager.saveCoreData(
            word: wordTextField.text ?? "",
            meaning: meaningTextField.text ?? "",
            memo: memoTextField.text ?? "",
            wordClass: tempWordClass)
        {
            self.savedCoreArray = self.appManager.getCoreDataArray()
            self.appManager.refreshDelegate?.refreshTableView()
            self.appManager.refreshDelegate?.refreshCalendar()
        }
        
        dismiss(animated: true)
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    //문제가 있구만
    @IBAction func wordClassButtonTapped(_ sender: UIButton) {
        guard let temp = sender.titleLabel?.text else {return}
        
        print(temp)
        
        switch temp {
        case " 명사":
            nounButton.isSelected.toggle()
            if tempWordClass.contains(" 명사") {
                if let firstIndex = tempWordClass.firstIndex(of: " 명사") {
                    tempWordClass.remove(at: firstIndex)
                }
            } else {
                tempWordClass.append(" 명사")
            }
            
            print(tempWordClass)
        case " 대명사":
            pronounButton.isSelected.toggle()
            if tempWordClass.contains(" 대명사") {
                if let firstIndex = tempWordClass.firstIndex(of: " 대명사") {
                    tempWordClass.remove(at: firstIndex)
                }
            } else {
                tempWordClass.append(" 대명사")
            }
            print(tempWordClass)
        case " 형용사":
            adjectiveButton.isSelected.toggle()
            if tempWordClass.contains(" 형용사") {
                if let firstIndex = tempWordClass.firstIndex(of: " 형용사") {
                    tempWordClass.remove(at: firstIndex)
                }
            } else {
                tempWordClass.append(" 형용사")
            }
            print(tempWordClass)
        case " 동사":
            verbButton.isSelected.toggle()
            if tempWordClass.contains(" 동사") {
                if let firstIndex = tempWordClass.firstIndex(of: " 동사") {
                    tempWordClass.remove(at: firstIndex)
                }
            } else {
                tempWordClass.append(" 동사")
            }
            print(tempWordClass)
        case " 부사":
            adverbButton.isSelected.toggle()
            if tempWordClass.contains(" 부사") {
                if let firstIndex = tempWordClass.firstIndex(of: " 부사") {
                    tempWordClass.remove(at: firstIndex)
                }
            } else {
                tempWordClass.append(" 부사")
            }
            print(tempWordClass)
        case " 전치사":
            prepositionButton.isSelected.toggle()
            if tempWordClass.contains(" 전치사") {
                if let firstIndex = tempWordClass.firstIndex(of: " 전치사") {
                    tempWordClass.remove(at: firstIndex)
                }
            } else {
                tempWordClass.append(" 전치사")
            }
            print(tempWordClass)
        case " 접속사":
            conjunctionButton.isSelected.toggle()
            if tempWordClass.contains(" 접속사") {
                if let firstIndex = tempWordClass.firstIndex(of: " 접속사") {
                    tempWordClass.remove(at: firstIndex)
                }
            } else {
                tempWordClass.append(" 접속사")
            }
            print(tempWordClass)
        case " 감탄사":
            interjectionButton.isSelected.toggle()
            if tempWordClass.contains(" 감탄사") {
                if let firstIndex = tempWordClass.firstIndex(of: " 감탄사") {
                    tempWordClass.remove(at: firstIndex)
                }
            } else {
                tempWordClass.append(" 감탄사")
            }
            print(tempWordClass)
        default:
            return
        }
    }
    
    
    
    func initialFunc() {
        wordTextField.delegate = self
        meaningTextField.delegate = self
        savedCoreArray = appManager.getCoreDataArray()
    }
    
    func appearenceFunc() {
        wordTextField.placeholder = "단어를 입력하세요."
        wordTextField.backgroundColor = Constants.customLightGrayColor
        wordTextField.layer.borderWidth = 0.1
        wordTextField.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        meaningTextField.placeholder = "뜻을 입력하세요."
        meaningTextField.backgroundColor = Constants.customLightGrayColor
        meaningTextField.layer.borderWidth = 0.1
        meaningTextField.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        memoTextField.placeholder = "메모를 입력하세요."
        memoTextField.backgroundColor = Constants.customLightGrayColor
        memoTextField.layer.borderWidth = 0.1
        memoTextField.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        saveButton.setTitle("저장", for: .normal)
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.setTitleColor(.lightGray, for: .highlighted)
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.setTitleColor(.lightGray, for: .highlighted)
        
        nounButton.titleLabel?.font = UIFont(name: "BMHANNAAir", size: 18)
        pronounButton.titleLabel?.font = UIFont(name: "BMHANNAAir", size: 18)
        adjectiveButton.titleLabel?.font = UIFont(name: "BMHANNAAir", size: 18)
        verbButton.titleLabel?.font = UIFont(name: "BMHANNAAir", size: 18)
        adverbButton.titleLabel?.font = UIFont(name: "BMHANNAAir", size: 18)
        prepositionButton.titleLabel?.font = UIFont(name: "BMHANNAAir", size: 18)
        conjunctionButton.titleLabel?.font = UIFont(name: "BMHANNAAir", size: 18)
        interjectionButton.titleLabel?.font = UIFont(name: "BMHANNAAir", size: 18)
    }
}


extension SaveViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        memoTextField.resignFirstResponder()
        meaningTextField.resignFirstResponder()
        wordTextField.resignFirstResponder()
        return true
    }
}
