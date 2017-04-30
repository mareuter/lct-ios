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
    @IBOutlet weak var cresentMoonWaxing: UIImageView!
    @IBOutlet weak var oldMoonInNewMoonsArms: UIImageView!
    @IBOutlet weak var cresentMoonWaning: UIImageView!
    @IBOutlet weak var newMoonInOldMoonsArms: UIImageView!
    @IBOutlet weak var cowJumpingOverMoon: UIImageView!
    @IBOutlet weak var manInTheMoon: UIImageView!
    @IBOutlet weak var womanInTheMoon: UIImageView!
    @IBOutlet weak var rabbitInTheMoon: UIImageView!
    
    private let indicatorOff = #imageLiteral(resourceName: "no-fill-star")
    private let indicatorOn = #imageLiteral(resourceName: "fill-star")
    
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
                    let tfnm = lunarClubInfo.timeFromNewMoon
                    if tfnm <= LunarClubConstants.timeCutoff {
                        timeFromNewMoon.text = formatDoubleLabel(value: tfnm, backCaption: " hours")
                        if tfnm > LunarClubConstants.timeWaxingCresent {
                            oldMoonInNewMoonsArms.image = indicatorOn
                        } else {
                            cresentMoonWaxing.image = indicatorOn
                        }
                    } else {
                        timeFromNewMoon.text = LunarClubConstants.timeLabelDefaultText
                        cresentMoonWaxing.image = indicatorOff
                        oldMoonInNewMoonsArms.image = indicatorOff
                    }
                    
                    let ttnm = lunarClubInfo.timeToNewMoon
                    if  ttnm <= LunarClubConstants.timeCutoff {
                        timeToNewMoon.text = formatDoubleLabel(value: ttnm, backCaption: " hours")
                        if ttnm > LunarClubConstants.timeWaningCresent {
                            newMoonInOldMoonsArms.image = indicatorOn
                        } else {
                            cresentMoonWaning.image = indicatorOn
                        }
                    } else {
                        timeToNewMoon.text = LunarClubConstants.timeLabelDefaultText
                        newMoonInOldMoonsArms.image = indicatorOff
                        cresentMoonWaning.image = indicatorOff
                    }
                    
                    let dtfm = lunarClubInfo.timeToFullMoon
                    if LunarClubConstants.timeCowJumping.contains(dtfm) {
                        cowJumpingOverMoon.image = indicatorOn
                    } else {
                        cowJumpingOverMoon.image = indicatorOff
                    }

                    if lunarClubInfo.fractionalPhase >= LunarClubConstants.fullMoonFraction {
                        manInTheMoon.image = indicatorOn
                        womanInTheMoon.image = indicatorOn
                        rabbitInTheMoon.image = indicatorOn
                    } else {
                        manInTheMoon.image = indicatorOff
                        womanInTheMoon.image = indicatorOff
                        rabbitInTheMoon.image = indicatorOff
                    }
                }
            }
        }
    }

}
