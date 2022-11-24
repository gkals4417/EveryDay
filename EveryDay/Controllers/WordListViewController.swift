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
    var savedCoreArray: [CoreData] = []{
        didSet {
            print("savedCoreArray Changed \n \(savedCoreArray)")
        }
    }
    
    var calendarSelectArray: [CoreData] = []{
        didSet {
            print("calendarSelectArray Changed \n \(calendarSelectArray)")
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialFunc()
    }

    func initialFunc(){
        calendarView.delegate = self
        calendarView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        savedCoreArray = appManager.getCoreDataArray()
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: "입력하세요.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "저장하기", style: .default) { UIAlertAction in
                self.appManager.saveCoreData(word: (alert.textFields?[0].text) ?? "", meaning: (alert.textFields?[1].text) ?? "", memo: "") {
                self.savedCoreArray = self.appManager.getCoreDataArray()
                self.tableView.reloadData()
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addTextField()
        alert.addTextField()
        alert.textFields?[0].placeholder = "단어를 입력하세요."
        alert.textFields?[1].placeholder = "뜻을 입력하세요."
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}


extension WordListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendarSelectArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifierWordListCell", for: indexPath) as! WordListCell
        cell.wordLabel.text = calendarSelectArray[indexPath.row].savedWord
        cell.meaningLabel.text = calendarSelectArray[indexPath.row].savedMeaning
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toWordDetailVC", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWordDetailVC" {
            let detailVC = segue.destination as! WordDetailViewController
            guard let indexPath = sender as? IndexPath else {return}
            detailVC.tempArray = calendarSelectArray[indexPath.row]
        }
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let subject = self.savedCoreArray[indexPath.row]
//            savedCoreArray.remove(at: indexPath.row)
//            appManager.coreDataArray.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            appManager.deleteCoreData(targetData: subject) {
//
//            }
//        } else if editingStyle == .insert {
//
//        }
//    }
}

extension WordListViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendarSelectArray = []
        for list in savedCoreArray {
            
            let a = list.savedDate?.formatted(date: .numeric, time: .omitted)
            let b = date.formatted(date: .numeric, time: .omitted)
            
            if a == b {
                calendarSelectArray.append(list)
            }
            
        }
        print("띠용? \(calendarSelectArray)")
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        var outNumber: Int = 0
        
        for list in savedCoreArray {
            let a = list.savedDate?.formatted(date: .numeric, time: .omitted)
            let b = date.formatted(date: .numeric, time: .omitted)
            
            if a == b {
                outNumber = 1
            } else {
                
            }
        }
        
        return outNumber
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return false
    }
}
