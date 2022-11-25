//
//  ToTalWordDetailViewController.swift
//  EveryDay
//
//  Created by Hamin Jeong on 2022/11/25.
//

import UIKit

class ToTalWordDetailViewController: UIViewController {

    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    @IBOutlet weak var memoTextField: UITextField!
    
    let appManager = EveryDayManager.shared
    
    var tempArray: CoreData? {
        didSet {
            print("Total Word Detail TempArray Changed \n \(tempArray)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memoTextField.delegate = self
        wordLabel.text = tempArray?.savedWord
        meaningLabel.text = tempArray?.savedMeaning
        memoTextField.text = tempArray?.savedDetailMemo
        memoTextField.placeholder = "메모를 입력하세요."
    }


}

extension ToTalWordDetailViewController: UITextFieldDelegate {
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
