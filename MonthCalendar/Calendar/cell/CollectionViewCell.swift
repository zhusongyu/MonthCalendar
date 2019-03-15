//
//  CollectionViewCell.swift
//  zotye
//
//  Created by 朱宋宇 on 2019/1/3.
//  Copyright © 2019 zhupeng. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var collectionCellView: CollectionCellView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(_ data: Any?, indexPath: IndexPath) {
        if let newData = data as? [CalendarModel], newData.count > 0 {
            collectionCellView.adapterModelToCollectionCellView(newData[indexPath.row])
        }
    }
}
