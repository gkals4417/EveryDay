//
//  ViewController.swift
//  EveryDay
//
//  Created by Hamin Jeong on 2022/11/08.
//

import UIKit

class WordListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let appManager = EveryDayManager.shared
    let timerVC = TimerViewController()
    
    var savedCoreArray: [CoreData] = []{
        didSet {
            print("SavedCoreArray Changed")
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup(){
        savedCoreArray = appManager.getCoreDataArray()
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func buttonTapped(_ sender: UIBarButtonItem) {
        print(#function)
        
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
        return savedCoreArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifierWordListCell", for: indexPath) as! WordListCell
        cell.wordLabel.text = savedCoreArray[indexPath.row].savedWord
        cell.meaningLabel.text = savedCoreArray[indexPath.row].savedMeaning
        cell.selectionStyle = .none
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toWordDetailVC", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWordDetailVC" {
            let detailVC = segue.destination as! WordDetailViewController
            
            guard let indexPath = sender as? IndexPath else {return}
            detailVC.tempArray = savedCoreArray[indexPath.row]
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let subject = self.savedCoreArray[indexPath.row]
            savedCoreArray.remove(at: indexPath.row)
            appManager.coreDataArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            appManager.deleteCoreData(targetData: subject) {
                
            }
        } else if editingStyle == .insert {
            
        }
    }
    
}
