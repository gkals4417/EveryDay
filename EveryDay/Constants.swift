//
//  Constants.swift
//  EveryDay
//
//  Created by Hamin Jeong on 2022/12/14.
//

import Foundation
import UIKit

struct Constants {
    static let customGrayColor: UIColor = UIColor(red: 179/255, green: 180/255, blue: 194/255, alpha: 1.0)
    static let customLightGrayColor: UIColor = UIColor(red: 245/255, green: 247/255, blue: 251/255, alpha: 1.0)
    static let customBlueColor: UIColor = UIColor(red: 78/255, green: 120/255, blue: 246/255, alpha: 1.0)
    
    static let customCGGrayColor: CGColor = CGColor(red: 179/255, green: 180/255, blue: 194/255, alpha: 1.0)
    static let customCGLightGrayColor: CGColor = CGColor(red: 245/255, green: 247/255, blue: 251/255, alpha: 1.0)
    static let customCGBlueColor: CGColor = CGColor(red: 78/255, green: 120/255, blue: 246/255, alpha: 1.0)
    
    static func naverURL(searchTerm: String) -> String {
        return "https://en.dict.naver.com/#/search?range=all&query=\(searchTerm)"
    }
}

struct Identifier {
    static let toWordDetailVC: String = "toWordDetailVC"
    static let wordListCell: String = "identifierWordListCell"
    static let toTotalWordDetailVC: String = "toTotalWordDetailVC"
    static let totalWordListCell: String = "identifierTotalWordListCell"
    static let toSaveVC: String = "toSaveVC"
}
