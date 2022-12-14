//
//  WordListCell.swift
//  EveryDay
//
//  Created by Hamin Jeong on 2022/12/01.
//

import UIKit

class WordListCell: UITableViewCell {

    @IBOutlet weak var meaningLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        contentView.layer.backgroundColor = Constants.customCGBlueColor
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0.1
        contentView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        meaningLabel.textColor = .white
        wordLabel.textColor = .white
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
