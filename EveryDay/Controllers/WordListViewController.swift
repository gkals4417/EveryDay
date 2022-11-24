//
//  ViewController.swift
//  EveryDay
//
//  Created by Hamin Jeong on 2022/11/08.
//

import UIKit
import FSCalendar

class WordListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarView: FSCalendar!
    
    private let appManager = EveryDayManager.shared

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func buttonTapped(_ sender: UIBarButtonItem) {
    }
}


//extension WordListViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//}

extension WordListViewController: FSCalendarDelegate, FSCalendarDataSource {
    
}
