//
//  SpecialViewController.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 4/26/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import UIKit

class SpecialViewController: UIViewController, UIUpdatable {

    private var delegate: UIUpdatable?
    private let hourFormatter = NumberFormatter()
    
    @IBOutlet weak var timeFromNewMoon: UILabel!
    @IBOutlet weak var timeToNewMoon: UILabel!
    
    override func viewDidLoad() {
        delegate = self
        super.viewDidLoad()
        setupHourFormatter()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    private func setupHourFormatter() {
        hourFormatter.minimumFractionDigits = 1
    }
    
    private func formatDoubleLabel(value: Double?, backCaption: String) -> String {
        let parameter = value ?? 0.0
        return hourFormatter.string(from: parameter as NSNumber)! + backCaption
    }

    func updateUI() {
        if view != nil {
            if let lcpvc = parent as? LunarClubPageViewController {
                if let lunarClubInfo = lcpvc.lunarClubInfo {
                    if lunarClubInfo.timeFromNewMoon <= LunarClubConstants.timeCutoff {
                        timeFromNewMoon.text = formatDoubleLabel(value: lunarClubInfo.timeFromNewMoon, backCaption: " hours")
                    } else {
                        timeFromNewMoon.text = LunarClubConstants.timeLabelDefaultText
                    }
                    
                    if lunarClubInfo.timeToNewMoon <= LunarClubConstants.timeCutoff {
                        timeToNewMoon.text = formatDoubleLabel(value: lunarClubInfo.timeToNewMoon, backCaption: " hours")
                    } else {
                        timeToNewMoon.text = LunarClubConstants.timeLabelDefaultText
                    }
                }
            }
        }
    }

}
