//
//  PresentCalendarView.swift
//  Test
//
//  Created 朱宋宇 on 2019/1/9.
//  Copyright © 2019 朱宋宇. All rights reserved.
//

import Foundation
import UIKit

protocol PresentCalendarViewDelegate: NSObjectProtocol {
    func yearCollectionViewDidSelect(presentCalendarView: PresentCalendarView)
    func monthCollectionViewDidSelect(presentCalendarView: PresentCalendarView)
}

@IBDesignable
class PresentCalendarView: UIView {
    
    @IBOutlet weak var yearCollectionView: UICollectionView!
    @IBOutlet weak var monthCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var monthCollectionViewHeight: NSLayoutConstraint!
    weak var delegate: PresentCalendarViewDelegate?

    var selectedYearIndex : Int = 0
    var selectedYear: Int = 0
    var selectedMonth: Int = 0
    
    enum Event: String {
        case yearCellDidClicked
        case monthCellDidClicked
    }
    
    var selectedDate: LaiCalendarView.SelectedDateModel = LaiCalendarView.SelectedDateModel() {
        didSet {
            selectedYear = selectedDate.selectedYear
            selectedMonth = selectedDate.selectedMonth
            updateTitle()
            setupMonth()
            let index = Utils.getCurrentYear() - selectedYear
            yearCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: true)
            yearCollectionView.layoutIfNeeded()

            initMonthArray = updateInitArray(initMonthArray, selectedMonth: selectedMonth)
        }
    }
    
    var yearArray: [Int] = [] {
        didSet {
            yearCollectionView.reloadData()
        }
    }
    
    var acceptMonthArray: Any? {
        didSet {
            if var array = acceptMonthArray as? [CalendarModel], array.count > 0 {
                setupMonth()
                for index in 0..<array.count {
                    let model = array[index]
                    let newModel = updateCalendarTitleColor(model.month.rawValue, model: model)
                    initMonthArray.remove(at: model.month.rawValue-1)
                    initMonthArray.insert(newModel, at: model.month.rawValue-1)
                }
            }
            monthCollectionView.reloadData()
        }
    }
    
    var initMonthArray: [CalendarModel] = [] {
        didSet {
            monthCollectionView.reloadData()
        }
    }
    
    func setup() {
        setupUI()
        setupYear()
        updateHeight()
    }
    
    func setupUI() {
        let contentNib = "CollectionViewCell"
        monthCollectionView.register(UINib.init(nibName: contentNib, bundle: nil), forCellWithReuseIdentifier: contentNib)
        let menuNib = "MenuCollectionViewCell"
        yearCollectionView.register(UINib.init(nibName: menuNib, bundle: nil), forCellWithReuseIdentifier: menuNib)
        
        let size = UIScreen.main.bounds.size
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: size.width/4, height: monthCollectionViewHeight.constant/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        monthCollectionView.collectionViewLayout = layout
    }
    
    func setupYear() {
        for index in 0..<5 {
            let year = Utils.getCurrentYear()-index
            if year >= PublishDate.year {
                yearArray.append(year)
            }
        }
    }
    
    func setupMonth() {
        var modelArray: [CalendarModel] = []
        for index in 1..<13 {
            var model = CalendarModel()
            model.subtitle = ""
            model.titleColor = UIColor.black
            model.month = Month(rawValue: index)!
            let newModel = updateCalendarTitleColor(index, model: model)
            modelArray.append(newModel)
        }
        initMonthArray = modelArray
    }
    
    func updateSelectedDate() {
        if selectedYear == Utils.getCurrentYear(), selectedMonth > Utils.getCurrentMonth() {
            selectedMonth = Utils.getCurrentMonth()
        }
        if selectedYear == PublishDate.year, selectedMonth < PublishDate.month {
            selectedMonth = PublishDate.month
        }
    }
    
    func updateTitle() {
        titleLabel.text = "\(selectedYear)年\(selectedMonth)月"
    }
    
    func updateInitArray(_ array: [CalendarModel], selectedMonth: Int) -> [CalendarModel] {
        var mutArray = array
        let model = mutArray[selectedMonth-1]
        let newModel = updateCalendarTitleColor(model.month.rawValue, model: model)
        mutArray.remove(at: model.month.rawValue-1)
        mutArray.insert(newModel, at: model.month.rawValue-1)
        return mutArray
    }
    
    func updateCalendarTitleColor(_ month: Int, model: CalendarModel) -> CalendarModel {
        var newModel = model
        if let title = self.titleLabel.text {
            let titleYear = title.prefix(4)
            let titleYearInt = Int(titleYear)
            if selectedYear >= Utils.getCurrentYear() {
                if Utils.getCurrentMonth() < month {
                    newModel.titleColor = UIColor.lightGray
                } else if selectedMonth == month, titleYearInt == selectedYear {
                    newModel.titleColor = UIColor.green
                } else {
                    newModel.titleColor = UIColor.black
                }
            } else if selectedYear <= PublishDate.year {
                if month < PublishDate.month {
                    newModel.titleColor = UIColor.lightGray
                } else if selectedMonth == month, titleYearInt == selectedYear {
                    newModel.titleColor = UIColor.green
                } else {
                    newModel.titleColor = UIColor.black
                }
            } else {
                if selectedMonth == month, titleYearInt == selectedYear {
                    newModel.titleColor = UIColor.green
                } else {
                    newModel.titleColor = UIColor.black
                }
            }
        }
        return newModel
    }
    
    func yearCellDidClicked(_ indexPath: IndexPath) {
        selectedYearIndex = indexPath.row
        selectedYear = yearArray[indexPath.row]
        setupMonth()
        yearCollectionView.reloadData()
        delegate?.yearCollectionViewDidSelect(presentCalendarView: self)
    }
    
    func monthCellDidClicked(_ indexPath: IndexPath) {
        selectedMonth = initMonthArray[indexPath.row].month.rawValue
        delegate?.monthCollectionViewDidSelect(presentCalendarView: self)
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

extension PresentCalendarView: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == monthCollectionView {
            return initMonthArray.count
        }
        
        if collectionView == yearCollectionView {
            return yearArray.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == monthCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: CollectionViewCell.self), for: indexPath) as? CollectionViewCell else {
                return CollectionViewCell()
            }
            
            if initMonthArray.count > 0 {
                cell.setup(initMonthArray, indexPath: indexPath)
            }
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: MenuCollectionViewCell.self), for: indexPath) as? MenuCollectionViewCell else {
            return MenuCollectionViewCell()
        }
        
        if yearArray.count > 0 {
            cell.setup(yearArray, selectedYear: selectedYear, indexPath: indexPath)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == yearCollectionView {
            yearCellDidClicked(indexPath)
        } else if collectionView == monthCollectionView {
            if initMonthArray.count > 0 {
                if selectedYear < Utils.getCurrentYear(), selectedYear > PublishDate.year {
                    monthCellDidClicked(indexPath)
                } else if selectedYear == PublishDate.year, indexPath.row+1 >= PublishDate.month {
                    monthCellDidClicked(indexPath)
                } else if selectedYear == Utils.getCurrentYear(), indexPath.row+1 <= Utils.getCurrentMonth() {
                    monthCellDidClicked(indexPath)
                }
            }
        }
    }
}
