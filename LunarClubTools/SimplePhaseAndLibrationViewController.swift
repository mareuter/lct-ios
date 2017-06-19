//
//  SimplePhaseAndLibrationViewController.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 4/21/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//
import UIKit

class SimplePhaseAndLibrationViewController: UIViewController, UIUpdatable
{    
    private var delegate: UIUpdatable?
    
    @IBOutlet weak var moonPhaseView: MoonPhaseView!
    
    override func viewDidLoad() {
        delegate = self
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    func updateUI() {
        if view != nil {
            if let mipvc = parent as? MoonInfoPageViewController {
                if let moonInfo = mipvc.moonInfo {
                    moonPhaseView.illumnationFraction = CGFloat(moonInfo.fractionalPhase)
                    moonPhaseView.librationLatitude = moonInfo.librationLatitude
                    moonPhaseView.librationLongitude = moonInfo.librationLongitude
                    var phaseId = 0
                    switch moonInfo.phaseName {
                    case "New Moon":
                        phaseId = 0
                    case "Full Moon":
                        phaseId = 2
                    case "Waxing Crescent", "First Quarter", "Waxing Gibbous":
                        phaseId = 1
                    case "Waning Gibbous", "Last Quarter", "Waning Crescent":
                        phaseId = 3
                    default:
                        break
                    }
                    moonPhaseView.phaseState = phaseId
                }
            }
        }
    }
}
