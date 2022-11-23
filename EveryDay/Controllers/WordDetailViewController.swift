//
//  WordDetailViewController.swift
//  EveryDay
//
//  Created by Hamin Jeong on 2022/11/09.
//

import UIKit

class WordDetailViewController: UIViewController {

    @IBOutlet weak var meaningDetailLabel: UILabel!
    @IBOutlet weak var wordDetailLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var memoTextField: UITextField!
    
    private let appManager = EveryDayManager.shared
    
    var tempArray: CoreData? {
        didSet {
            print("\(String(describing: tempArray))")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memoTextField.delegate = self
        wordDetailLabel.text = tempArray?.savedWord
        meaningDetailLabel.text = tempArray?.savedMeaning
        memoTextField.text = tempArray?.savedDetailMemo
        memoTextField.placeholder = "메모를 입력하세요."
    }
}

extension WordDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let temp = tempArray {
            temp.savedDetailMemo = textField.text
            appManager.updateCoreData(newCoreData: temp) {
                
            }
        }
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
