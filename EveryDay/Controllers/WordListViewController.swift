//
//  ViewController.swift
//  EveryDay
//
//  Created by Hamin Jeong on 2022/11/08.
//

import UIKit

class WordListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let appManager = EveryDayManager.shared
    
    var savedCoreArray: [CoreData] = []{
        didSet {
            print(savedCoreArray)
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
        appManager.saveCoreData(word: "Hello", meaning: "안녕", memo: "") {
            
        }
        savedCoreArray = appManager.getCoreDataArray()
        tableView.reloadData()
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
    
}
