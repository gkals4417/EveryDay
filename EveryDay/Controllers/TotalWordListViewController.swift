//
//  TotalWordListViewController.swift
//  EveryDay
//
//  Created by Hamin Jeong on 2022/11/25.
//

import UIKit
import AVFoundation

final class TotalWordListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let appManager = EveryDayManager.shared
    private let refreshController: UIRefreshControl = UIRefreshControl()
    private var savedCoreArray: [CoreData] = [] {
        didSet {
            print("Total ViewController savedCoreArray changed \n \(savedCoreArray)")
        }
    }
    private var filteredArray: [CoreData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TotalWordListCell", bundle: nil), forCellReuseIdentifier: Identifier.totalWordListCell)
        initialFunc()
    }

    override func viewWillAppear(_ animated: Bool) {
        savedCoreArray = appManager.getCoreDataArray()
        tableView.reloadData()
        tableView.separatorStyle = .none
    }
    
    func initialFunc() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshController
        refreshController.addTarget(self, action: #selector(self.refreshFunc), for: .valueChanged)
        savedCoreArray = appManager.getCoreDataArray()
    }
    
    @objc func refreshFunc() {
        savedCoreArray = appManager.getCoreDataArray()
        tableView.reloadData()
        refreshController.endRefreshing()
        AudioServicesPlaySystemSound(1102)
    }
    
}

extension TotalWordListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedCoreArray.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.totalWordListCell, for: indexPath) as! TotalWordListCell
        cell.totalWordLabel.text = savedCoreArray[indexPath.row].savedWord
        cell.totalWordMeaningLabel.text = savedCoreArray[indexPath.row].savedMeaning
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Identifier.toTotalWordDetailVC, sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifier.toTotalWordDetailVC {
            let totalDetailVC = segue.destination as! ToTalWordDetailViewController
            guard let indexPath = sender as? IndexPath else {return}
            totalDetailVC.tempArray = savedCoreArray[indexPath.row]
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

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel()
        header.text = "   LIST"
        header.font = UIFont(name: "BMHANNAAir", size: 20)
        header.backgroundColor = .white

        return header
    }
}

