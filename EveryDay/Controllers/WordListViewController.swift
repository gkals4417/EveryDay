//
//  ViewController.swift
//  EveryDay
//
//  Created by Hamin Jeong on 2022/11/08.
//

import UIKit
import FSCalendar
import AVFoundation

class WordListViewController: UIViewController {
    
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarView: FSCalendar!
    
    let refreshController: UIRefreshControl = UIRefreshControl()

    var currentPage = Date()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        calendarView.reloadData()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialFunc()
        appearanceFunc()
        tableView.register(UINib(nibName: "WordListCell", bundle: nil), forCellReuseIdentifier: "identifierWordListCell")
    }

    private func initialFunc(){
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
    
    @objc func refreshFunc(){
        calendarView.reloadData()
        tableView.reloadData()
        refreshController.endRefreshing()
        AudioServicesPlaySystemSound(1102)
    }
    
    
    
    private func appearanceFunc(){
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        calendarView.backgroundColor = .white
        todayButton.setTitle("오늘", for: .normal)
        todayButton.setTitleColor(.black, for: .normal)
        
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        calendarView.appearance.subtitleTodayColor = .black
        calendarView.appearance.titleTodayColor = .black
        calendarView.appearance.selectionColor = .black
        calendarView.appearance.headerTitleColor = .black
        calendarView.appearance.titleWeekendColor = .red
        calendarView.appearance.todayColor = .white
        calendarView.appearance.eventDefaultColor = .black
        calendarView.appearance.eventSelectionColor = .black
        calendarView.appearance.borderRadius = 0.1
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
        let alert = UIAlertController(title: nil, message: "추가", preferredStyle: .alert)
        alert.view.tintColor = .black
        alert.view.backgroundColor = .lightGray
        alert.view.layer.cornerRadius = 20
        let ok = UIAlertAction(title: "저장", style: .default) { UIAlertAction in
                self.appManager.saveCoreData(word: (alert.textFields?[0].text) ?? "", meaning: (alert.textFields?[1].text) ?? "", memo: "") {
                self.savedCoreArray = self.appManager.getCoreDataArray()
                self.tableView.reloadData()
                    self.calendarView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifierWordListCell", for: indexPath) as! WordListCell
        cell.wordLabel.text = calendarSelectArray[indexPath.row].savedWord
        cell.meaningLabel.text = calendarSelectArray[indexPath.row].savedMeaning
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let imageView = UIImageView()
        let myImage: UIImage = UIImage(named: "LIST")!
        imageView.image = myImage
        
        let header = UIView()
        header.backgroundColor = .white
        header.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 20).isActive = true
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
