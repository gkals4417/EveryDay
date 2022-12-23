//
//  ToTalWordDetailViewController.swift
//  EveryDay
//
//  Created by Hamin Jeong on 2022/11/25.
//

import UIKit
import WebKit

final class ToTalWordDetailViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    @IBOutlet weak var memoTextField: UITextField!
    private let appManager = EveryDayManager.shared
    var tempArray: CoreData? {
        didSet {
            print("Total Word Detail TempArray Changed \n \(String(describing: tempArray))")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification: )), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
        wordLabel.text = tempArray?.savedWord
        meaningLabel.text = tempArray?.savedMeaning
        memoTextField.text = tempArray?.savedDetailMemo
        memoTextField.placeholder = "메모를 입력하세요."
    }
    
    private func appearanceFunc() {
        wordLabel.backgroundColor = Constants.customLightGrayColor
        meaningLabel.backgroundColor = Constants.customLightGrayColor
        
        wordLabel.font = UIFont(name: "BMHANNAPro", size: 30)
        meaningLabel.font = UIFont(name: "BMHANNAPro", size: 25)
        memoTextField.font = UIFont(name: "BMHANNAPro", size: 20)
//        memoTextField.layer.cornerRadius = 15
        memoTextField.backgroundColor = Constants.customLightGrayColor
        memoTextField.layer.masksToBounds = true
        memoTextField.layer.borderWidth = 0.1
        memoTextField.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
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
        
    func webViewFunc(){
        guard let searchTerm = wordLabel.text else {return}
        guard let url = URL(string: Constants.naverURL(searchTerm: searchTerm)) else {return}
        let request = URLRequest(url: url)
        DispatchQueue.main.async {
            self.webView.load(request)
        }
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

extension ToTalWordDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.spinner.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.spinner.stopAnimating()
        spinner.hidesWhenStopped = true
    }
}
