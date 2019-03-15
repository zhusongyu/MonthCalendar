//
//  LaiCalendarView.swift
//  Calander
//
//  Created 朱宋宇 on 2019/1/3.
//  Copyright © 2019 朱宋宇. All rights reserved.
//

import Foundation
import UIKit

struct PublishDate {
    static let year = 2015
    static let month = 4
}

struct Utils {
    static func getCurrentMonth() -> Int {
        let calendar = NSCalendar.current
        let month = calendar.component(.month, from: Date())
        return month
    }
    
    static func getCurrentYear() -> Int {
        let calendar = NSCalendar.current
        let year = calendar.component(.year, from: Date())
        return year
    }
}

struct CalendarModel {
    var subtitle = ""
    var subTitleColor = UIColor.clear
    var titleColor = UIColor.black
    var month: Month = .January
}

enum Month: Int {
    case January = 1
    case February
    case March
    case April
    case May
    case June
    case July
    case August
    case September
    case October
    case November
    case December
}

protocol LaiCalendarViewDelegate: NSObjectProtocol {
    func moreButtonDidClicked(laiCalendarView: LaiCalendarView)
    func leftButtonDidClicked(laiCalendarView: LaiCalendarView)
    func rightButtonDidClicked(laiCalendarView: LaiCalendarView)
}

public class LaiCalendarView: UIView {
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    weak var delegate: LaiCalendarViewDelegate?
    
    var selectedMonth: Int = 0
    var selectedYear: Int = 0
    
    struct SelectedDateModel {
        var selectedYear: Int = Utils.getCurrentYear()
        var selectedMonth: Int = Utils.getCurrentMonth()
    }
    
    func setup() {
        setupData()
        updateHeight()
    }
    
    func setupData() {
        selectedYear = Utils.getCurrentYear()
        selectedMonth = Utils.getCurrentMonth()
        updateTitle()
        updateButtonStatus()
    }
    
    func updateTitle() {
        titleLabel.text = "\(selectedYear)年\(selectedMonth)月"
    }
    
    func updateButtonStatus() {
        if canForward(selectedYear, month: selectedMonth) == true {
            self.leftButton.isUserInteractionEnabled = true
            self.leftButton.setImage(UIImage(named: "icon_arrow_left_black"), for: .normal)
        } else {
            self.leftButton.isUserInteractionEnabled = false
            self.leftButton.setImage(UIImage(named: "icon_arrow_left_gray"), for: .normal)
        }
        if canBack(selectedYear, month: selectedMonth) == true {
            self.rightButton.isUserInteractionEnabled = true
            self.rightButton.setImage(UIImage(named: "icon_arrow_right_black"), for: .normal)
        } else {
            self.rightButton.isUserInteractionEnabled = false
            self.rightButton.setImage(UIImage(named: "icon_arrow_right_gray"), for: .normal)
        }
    }
    
    func backMonth() {
        self.selectedMonth -= 1
        if selectedMonth == 0 {
            selectedMonth = 12
            selectedYear -= 1
        }
        updateTitle()
        updateButtonStatus()
    }
    
    func forwardMonth() {
        self.selectedMonth += 1
        if selectedMonth == 13 {
            selectedMonth = 1
            selectedYear += 1
        }
        updateTitle()
        updateButtonStatus()
    }
    
    func canForward(_ year: Int, month: Int) -> Bool {
        if year >= Utils.getCurrentYear() {
            if month >= Utils.getCurrentMonth() {
                return false
            }
        }
        return true
    }
    
    func canBack(_ year: Int, month: Int) -> Bool {
        if year < PublishDate.year {
            return false
        }
        if year == PublishDate.year, month <= PublishDate.month {
            return false
        }
        if year <= Utils.getCurrentYear() - 5 {
            if month <= Utils.getCurrentMonth() {
                return false
            }
        }
        return true
    }
    
    @IBAction func moreBtnClick(_ sender: Any) {
        delegate?.moreButtonDidClicked(laiCalendarView: self)
    }
    
    @IBAction func leftBtnClick(_ sender: Any) {
        self.forwardMonth()
        delegate?.leftButtonDidClicked(laiCalendarView: self)
    }
    
    @IBAction func rightBtnClick(_ sender: Any) {
        self.backMonth()
        delegate?.rightButtonDidClicked(laiCalendarView: self)
    }
    
    override public var intrinsicContentSize: CGSize {
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
    
    override public func layoutSubviews() {
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
