//
//  ChangeTimeViewController.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 3/30/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import UIKit

class ChangeTimeViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!

    @IBAction func now(_ sender: UIButton) {
        datePicker.date = Date()
    }

    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        print(datePicker.date)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.datePickerMode = .date
        datePicker.datePickerMode = .dateAndTime
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let popoverPresentationController = navigationController?.popoverPresentationController {
            if popoverPresentationController.arrowDirection != .unknown {
                navigationItem.leftBarButtonItem = nil
            }
        }
        preferredContentSize = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let nc = NotificationCenter.default
        nc.post(name: ProgramConstants.changeTimeNotification,
                object: nil, userInfo: ["date": datePicker.date])
    }
}
