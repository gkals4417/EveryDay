//
//  ViewController.swift
//  EveryDay
//
//  Created by Hamin Jeong on 2022/11/08.
//

import UIKit
import FSCalendar
import AVFoundation

final class WordListViewController: UIViewController {
    
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarView: FSCalendar!
    
    private let refreshController: UIRefreshControl = UIRefreshControl()
    private var currentPage = Date()
    private let appManager = EveryDayManager.shared
    private var savedCoreArray: [CoreData] = [] {
        didSet {
            print("savedCoreArray Changed \n \(savedCoreArray)")
        }
    }
    
    private var calendarSelectArray: [CoreData] = [] {
        didSet {
            print("calendarSelectArray Changed \n \(calendarSelectArray)")
            tableView.reloadData()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        calendarView.reloadData()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appManager.refreshDelegate = self
        initialFunc()
        appearanceFunc()
        tableView.register(UINib(nibName: "WordListCell", bundle: nil), forCellReuseIdentifier: Identifier.wordListCell)
    }

    private func initialFunc() {
        calendarView.delegate = self
        calendarView.dataSource = self
        
        calendarView.appearance.headerDateFormat = "YYYY년 M월"
        calendarView.locale = Locale(identifier: "ko_KR")
        
        tableView.delegate = self
        tableView.dataSource = self
        savedCoreArray = appManager.getCoreDataArray()
        
        tableView.refreshControl = refreshController
        refreshController.addTarget(self, action: #selector(self.refreshFunc), for: .valueChanged)
    }
    
    @objc func refreshFunc() {
        calendarView.reloadData()
        tableView.reloadData()
        refreshController.endRefreshing()
        AudioServicesPlaySystemSound(1102)
    }
    
    private func appearanceFunc() {
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        calendarView.backgroundColor = .white
        todayButton.setTitle("오늘", for: .normal)
        todayButton.setTitleColor(.black, for: .normal)
        todayButton.setTitleColor(.lightGray, for: .highlighted)
        
        calendarView.appearance.titleFont = UIFont(name: "BMHANNAAir", size: 15)
        calendarView.appearance.weekdayFont = UIFont(name: "BMHANNAAir", size: 15)
        calendarView.appearance.subtitleFont = UIFont(name: "BMHANNAAir", size: 10)
        calendarView.appearance.headerTitleFont = UIFont(name: "BMHANNAAir", size: 20)
        
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        calendarView.appearance.subtitleTodayColor = .black
        calendarView.appearance.titleTodayColor = .black
        calendarView.appearance.selectionColor = Constants.customBlueColor
        calendarView.appearance.headerTitleColor = .black
        calendarView.appearance.titleWeekendColor = .red
        calendarView.appearance.todayColor = .white
        calendarView.appearance.eventDefaultColor = Constants.customBlueColor
        calendarView.appearance.eventSelectionColor = Constants.customBlueColor
        calendarView.appearance.borderRadius = 0.5
        calendarView.swipeToChooseGesture.isEnabled = true
        
        calendarView.calendarWeekdayView.weekdayLabels[0].textColor = .red
        calendarView.calendarWeekdayView.weekdayLabels[1].textColor = .black
        calendarView.calendarWeekdayView.weekdayLabels[2].textColor = .black
        calendarView.calendarWeekdayView.weekdayLabels[3].textColor = .black
        calendarView.calendarWeekdayView.weekdayLabels[4].textColor = .black
        calendarView.calendarWeekdayView.weekdayLabels[5].textColor = .black
        calendarView.calendarWeekdayView.weekdayLabels[6].textColor = .red
        
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
//        let alert = UIAlertController(title: nil, message: "추가", preferredStyle: .alert)
//        let ok = UIAlertAction(title: "저장", style: .default) { UIAlertAction in
//                self.appManager.saveCoreData(word: (alert.textFields?[0].text) ?? "", meaning: (alert.textFields?[1].text) ?? "", memo: "") {
//                self.savedCoreArray = self.appManager.getCoreDataArray()
//                self.tableView.reloadData()
//                    self.calendarView.reloadData()
//            }
//        }
//        let cancel = UIAlertAction(title: "취소", style: .cancel)
//        alert.addTextField()
//        alert.addTextField()
//        alert.textFields?[0].placeholder = "단어를 입력하세요."
//        alert.textFields?[1].placeholder = "뜻을 입력하세요."
//        alert.addAction(ok)
//        alert.addAction(cancel)
//        present(alert, animated: true)
        performSegue(withIdentifier: Identifier.toSaveVC, sender: sender)
    }
    
    @IBAction func todayButtonTapped(_ sender: UIButton) {
        print(#function)
        calendarView.setCurrentPage(currentPage, animated: true)
    }
}


extension WordListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendarSelectArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.wordListCell, for: indexPath) as! WordListCell
        cell.wordLabel.text = calendarSelectArray[indexPath.row].savedWord
        cell.meaningLabel.text = calendarSelectArray[indexPath.row].savedMeaning
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Identifier.toWordDetailVC, sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifier.toWordDetailVC {
            let detailVC = segue.destination as! WordDetailViewController
            guard let indexPath = sender as? IndexPath else { return }
            detailVC.tempArray = calendarSelectArray[indexPath.row]
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let header = UILabel()
        header.text = "   LIST"
        header.font = UIFont(name: "BMHANNAAir", size: 20)
        header.backgroundColor = .white

        return header
    }
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
        print("calendarSelectArray after select date : \(calendarSelectArray)")
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendarSelectArray = []
        
        for list in savedCoreArray {
            let today = Date().formatted(date: .numeric, time: .omitted)
            let a = list.savedDate?.formatted(date: .numeric, time: .omitted)
            
            if today == a {
                calendarSelectArray.append(list)
            }
        }
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
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        let today = Date()
        var temp = ""
        if today.formatted(date: .numeric, time: .omitted) == date.formatted(date: .numeric, time: .omitted){
            temp = "오늘"
        }
        return temp
    }
}

extension WordListViewController: RefreshDelegate {
    func refreshTableView() {
        savedCoreArray = appManager.getCoreDataArray()
        tableView.reloadData()
    }
    
    func refreshCalendar() {
        savedCoreArray = appManager.getCoreDataArray()
        calendarView.reloadData()
    }
}
