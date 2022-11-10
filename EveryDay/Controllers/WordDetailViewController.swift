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
    
    var tempArray: CoreData? {
        didSet {
            print(tempArray)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordDetailLabel.text = tempArray?.savedWord
        meaningDetailLabel.text = tempArray?.savedMeaning
    }
    

    @IBAction func detailButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

}
