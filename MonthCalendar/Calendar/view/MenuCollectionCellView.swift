//
//  MenuCollectionCellView.swift
//  zotye
//
//  Created 朱宋宇 on 2019/1/3.
//  Copyright © 2019 zhupeng. All rights reserved.
//

import Foundation
import UIKit

class MenuCollectionCellView: UIView {
        
    @IBOutlet weak var titleLabel: UILabel!

    func setup() {
        updateHeight()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize.init(width: UIViewNoIntrinsicMetric, height: dynamicHeight())
    }
    
    func updateHeight() {
        layoutIfNeeded()
        self.frame.size.height = dynamicHeight()
        invalidateIntrinsicContentSize()
    }
    
    func dynamicHeight() -> CGFloat {
        if let lastView = self.subviews.last?.subviews.last {
            let bottom = lastView.frame.origin.y + lastView.frame.size.height
            return bottom
        }
        return 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
        setup()
    }
    
    fileprivate func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        let nib = UINib.init(nibName: nibName, bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        insertSubview(view, at: 0)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
