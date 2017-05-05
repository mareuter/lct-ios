//
//  ChangeTimeViewController.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 3/30/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import UIKit

class ChangeTimeViewController: UIViewController {
    private var loadDate = Date()

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!

    @IBAction func now(_ sender: UIButton) {
        datePicker.date = Date()
    }

    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.datePickerMode = .date
        timePicker.setValue(UIColor.white, forKey: "textColor")
        timePicker.datePickerMode = .time
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let popoverPresentationController = navigationController?.popoverPresentationController {
            if popoverPresentationController.arrowDirection != .unknown {
                navigationItem.leftBarButtonItem = nil
            }
        }
        preferredContentSize = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        loadDate = timePicker.date
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let nc = NotificationCenter.default

        let timeDifference = timePicker.date.timeIntervalSince(loadDate)
        let newDate = datePicker.date + timeDifference

        nc.post(name: ProgramConstants.changeTimeNotification,
                object: nil, userInfo: ["date": newDate])
    }
}
