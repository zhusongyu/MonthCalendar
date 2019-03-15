//
//  ViewController.swift
//  Test
//
//  Created by 朱宋宇 on 2019/1/4.
//  Copyright © 2019 朱宋宇. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var contentView: LaiCalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }


}

extension ViewController: LaiCalendarViewDelegate {
    func moreButtonDidClicked(laiCalendarView: LaiCalendarView) {
        var model = LaiCalendarView.SelectedDateModel()
        model.selectedYear = laiCalendarView.selectedYear
        model.selectedMonth = laiCalendarView.selectedMonth
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PresentViewController") as! PresentViewController
        vc.selectedDate = model
        vc.callback = { (year, month) in
            self.contentView.selectedYear = year
            self.contentView.selectedMonth = month
            self.contentView.titleLabel.text = "\(year)年\(month)月"
            self.contentView.updateButtonStatus()
        }
        vc.yearSelectedCallback = { (year, presentView) in
            switch year {
            case 2018:
                var model1 = CalendarModel()
                model1.month = .April
                model1.subtitle = "处理中"
                model1.subTitleColor = .blue
                
                presentView.adapterModelToPresentCalendarView([model1])
            case 2017:
                var model1 = CalendarModel()
                model1.month = .July
                model1.subtitle = "处理中"
                model1.subTitleColor = .blue
                
                presentView.adapterModelToPresentCalendarView([model1])
            default:
                break
            }
        }
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    func leftButtonDidClicked(laiCalendarView: LaiCalendarView) {
        
    }
    
    func rightButtonDidClicked(laiCalendarView: LaiCalendarView) {
        
    }
}

