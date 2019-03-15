//
//  PresentViewController.swift
//  Test
//
//  Created by 朱宋宇 on 2019/1/9.
//  Copyright © 2019 朱宋宇. All rights reserved.
//

import UIKit

class PresentViewController: UIViewController {

    var selectedDate: LaiCalendarView.SelectedDateModel = LaiCalendarView.SelectedDateModel()
    var callback: ((_ year: Int, _ month: Int) -> Void)?
    var yearSelectedCallback: ((_ year: Int, _ presentView: PresentCalendarView) -> Void)?

    @IBOutlet weak var contentView: PresentCalendarView!
    @IBOutlet weak var bottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentView.selectedDate = selectedDate
        setupEvent()
        contentView.delegate = self
        if let callback = self.yearSelectedCallback {
            let selectedYear = contentView.selectedYear
            callback(selectedYear, contentView)
        }
        
        // Do any additional setup after loading the view.
    }

    func setupEvent() {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector (bottomViewTap))
        bottomView.addGestureRecognizer(tapGesture)
    }
    
    @objc func bottomViewTap() {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PresentViewController: PresentCalendarViewDelegate {
    func yearCollectionViewDidSelect(presentCalendarView: PresentCalendarView) {
        if let callback = self.yearSelectedCallback {
            let selectedYear = presentCalendarView.selectedYear
            callback(selectedYear, contentView)
        }
    }
    
    func monthCollectionViewDidSelect(presentCalendarView: PresentCalendarView) {
        if let callback = self.callback {
            let year = presentCalendarView.selectedYear
            let month = presentCalendarView.selectedMonth
            callback(year, month)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

