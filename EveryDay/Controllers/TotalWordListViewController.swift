//
//  TotalWordListViewController.swift
//  EveryDay
//
//  Created by Hamin Jeong on 2022/11/25.
//

import UIKit
import AVFoundation

class TotalWordListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let appManager = EveryDayManager.shared
    let refreshController: UIRefreshControl = UIRefreshControl()
    
    var savedCoreArray: [CoreData] = []{
        didSet {
            print("Total ViewController savedCoreArray changed \n \(savedCoreArray)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TotalWordListCell", bundle: nil), forCellReuseIdentifier: "identifierTotalWordListCell")
        initialFunc()
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func initialFunc(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshController
        refreshController.addTarget(self, action: #selector(self.refreshFunc), for: .valueChanged)
        savedCoreArray = appManager.getCoreDataArray()
    }
    
    @objc func refreshFunc(){
        savedCoreArray = appManager.getCoreDataArray()
        tableView.reloadData()
        refreshController.endRefreshing()
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
}

extension TotalWordListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedCoreArray.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifierTotalWordListCell", for: indexPath) as! TotalWordListCell
        
        cell.totalWordLabel.text = savedCoreArray[indexPath.row].savedWord
        cell.totalWordMeaningLabel.text = savedCoreArray[indexPath.row].savedMeaning
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toTotalWordDetailVC", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTotalWordDetailVC" {
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
        let imageView = UIImageView()
        let myImage: UIImage = UIImage(named: "LIST")!
        imageView.image = myImage
        
        let header = UIView()
        header.backgroundColor = .white
        header.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 20).isActive = true
//        imageView.centerXAnchor.constraint(equalTo: header.centerXAnchor).isActive = true
//        imageView.centerYAnchor.constraint(equalTo: header.centerYAnchor).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
//        imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        return header
    }
}
