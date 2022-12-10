//
//  InformationViewController.swift
//  EveryDay
//
//  Created by Hamin Jeong on 2022/12/06.
//

import UIKit

class InformationViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    let appManager = EveryDayManager.shared
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    var receivedArray: [Int] = [] {
        didSet {
            print("receivedArray \(receivedArray)")
        }
    }
    let menuArray = ["총 단어 갯수", "문제 평점", "제작 정보", "아이콘"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialFunc()
        collectionView.delegate = self
        collectionView.dataSource = self
        view.backgroundColor = .white
    }
    
    private func initialFunc(){
        guard let temp = appManager.delegate?.getInfo() else { return }
        receivedArray = temp
        
        
    }
    
}

extension InformationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoCell", for: indexPath) as! InfoCell
        cell.testLabel.text = menuArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.frame.width
            let height = collectionView.frame.height
            let itemsPerRow: CGFloat = 2
            let widthPadding = sectionInsets.left * (itemsPerRow - 1)
            let itemsPerColumn: CGFloat = 2
            let heightPadding = sectionInsets.top * (itemsPerColumn + 1)
            let cellWidth = (width - widthPadding) / itemsPerRow
            let cellHeight = (height - heightPadding) / itemsPerColumn
            
            return CGSize(width: cellWidth, height: cellHeight)
            
        }
    
}
