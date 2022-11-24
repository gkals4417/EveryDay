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
    @IBOutlet weak var memoTextField: UITextField!
    
    private let appManager = EveryDayManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension WordDetailViewController: UITextFieldDelegate {

}
