//
//  ResultCollectionViewCell.swift
//  SearchTest
//
//  Created by Chen Zhi-Han on 2020/7/22.
//  Copyright © 2020 Chen Zhi-Han. All rights reserved.
//

import UIKit

class ResultCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lable: UILabel!
    @IBOutlet weak var img: UIImageView!
    var imageURL: URL!
    
    func initUI() {
        let w = Double(UIScreen.main.bounds.size.width)/2 - 5
        img.frame = CGRect(x: 0, y: 0, width: w, height: w/2 + 10)
        lable.frame = CGRect(x: 0, y: w/2 + 10, width: w, height: w/2 - 10)
        lable.textAlignment = .center
    }
}
