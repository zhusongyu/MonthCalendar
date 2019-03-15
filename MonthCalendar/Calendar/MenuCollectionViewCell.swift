//
//  MenuCollectionViewCell.swift
//  zotye
//
//  Created by 朱宋宇 on 2019/1/3.
//  Copyright © 2019 zhupeng. All rights reserved.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellView: MenuCollectionCellView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(_ data: Any?, selectedYear: Int, indexPath: IndexPath) {
        if let strArray = data as? [Int] {
            cellView.titleLabel.text = "\(strArray[indexPath.row])年"
            if selectedYear == strArray[indexPath.row] {
                cellView.titleLabel.textColor = UIColor.black
            } else {
                cellView.titleLabel.textColor = UIColor.lightGray
            }
        }
    }
}
