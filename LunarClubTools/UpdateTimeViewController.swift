//
//  UpdateTimeViewController.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 3/30/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import UIKit

class UpdateTimeViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!

    @IBAction func now(_ sender: UIButton) {
        datePicker.date = Date()
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        print(datePicker.date)
        presentingViewController?.dismiss(animated: true, completion: nil)
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("UpdateTimeNotification"), object: nil, userInfo: ["date": datePicker.date])
    }
}
