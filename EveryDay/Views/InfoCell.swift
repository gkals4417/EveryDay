//
//  InfoCell.swift
//  EveryDay
//
//  Created by Hamin Jeong on 2022/12/08.
//

import UIKit

class InfoCell: UICollectionViewCell {
    
    @IBOutlet weak var testLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let cvRect = contentView.frame
        
        contentView.layer.backgroundColor = CGColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 0.5)
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0.1
        contentView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
}
