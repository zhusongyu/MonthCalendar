//
//  CollectionCellViewAdapter.swift
//  zotye
//
//  Created 朱宋宇 on 2019/1/3.
//  Copyright © 2019 zhupeng. All rights reserved.
//

import Foundation
import UIKit

extension CollectionCellView {
    func adapterModelToCollectionCellView(_ model:CalendarModel) {
        self.titleLabel.text = "\(model.month.rawValue)月"
        self.subtitleLabel.text = model.subtitle
        self.titleLabel.textColor = model.titleColor
        self.subtitleLabel.backgroundColor = model.subTitleColor
        if model.subTitleColor == UIColor.clear {
            self.subtitleLabel.isHidden = true
        } else {
            self.subtitleLabel.isHidden = false
        }
    }
}
