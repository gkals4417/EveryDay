//
//  WordDetailViewController.swift
//  EveryDay
//
//  Created by Hamin Jeong on 2022/11/09.
//

import UIKit
import WebKit

final class WordDetailViewController: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var meaningDetailLabel: UILabel!
    @IBOutlet weak var wordDetailLabel: UILabel!
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var wordClassTextView: UITextView!
    
    private let appManager = EveryDayManager.shared
    var tempArray: CoreData? {
        didSet {
            print("tempArray Changed : \n \(String(describing: tempArray))")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialFunc()
        appearanceFunc()
        webViewFunc()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func initialFunc() {
        webView.navigationDelegate = self
        memoTextField.delegate = self
        wordDetailLabel.text = tempArray?.savedWord
        meaningDetailLabel.text = tempArray?.savedMeaning
        memoTextField.text = tempArray?.savedDetailMemo
        memoTextField.placeholder = "메모를 입력하세요."
        
        let reduceNames: String = (tempArray?.wordClass?.reduce("품사 : ") {
            return $0 + "\n" + $1
        })!
        
        print(reduceNames)
        
        wordClassTextView.text = reduceNames
    }
    
    private func appearanceFunc() {
        wordDetailLabel.backgroundColor = Constants.customLightGrayColor
        meaningDetailLabel.backgroundColor = Constants.customLightGrayColor
        
        wordDetailLabel.font = UIFont(name: "BMHANNAPro", size: 30)
        meaningDetailLabel.font = UIFont(name: "BMHANNAPro", size: 25)
        memoTextField.font = UIFont(name: "BMHANNAPro", size: 20)
        
//        memoTextField.layer.cornerRadius = 15
        memoTextField.backgroundColor = Constants.customLightGrayColor
        memoTextField.layer.masksToBounds = true
        memoTextField.layer.borderWidth = 0.1
        memoTextField.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        wordClassTextView.font = UIFont(name: "BMHANNAPro", size: 18)
        wordClassTextView.layer.masksToBounds = true
        wordClassTextView.layer.borderWidth = 0.1
        wordClassTextView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
    //with line below ,we can get the keyboard size.
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
        view.frame.origin.y -= keyboardSize.height
    }
    }
    @objc func keyboardWillHide(notification: Notification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
        view.frame.origin.y += keyboardSize.height
    }
    }
    
    func webViewFunc(){
        guard let searchTerm = wordDetailLabel.text else {return}
        guard let url = URL(string: Constants.naverURL(searchTerm: searchTerm)) else { return }
        let request = URLRequest(url: url)
        DispatchQueue.main.async {
            self.webView.load(request)
        }
    }
}

extension WordDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let temp = tempArray {
            temp.savedDetailMemo = textField.text
            appManager.updateCoreData(newCoreData: temp) {
            //이부분에 품사저장 메서드 추가해야 함.
            }
        }
        textField.resignFirstResponder()
        dismiss(animated: true)
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification: )), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension WordDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.spinner.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.spinner.stopAnimating()
        spinner.hidesWhenStopped = true
    }
}
