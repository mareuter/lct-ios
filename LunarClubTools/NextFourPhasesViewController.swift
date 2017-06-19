//
//  NextFourPhasesViewController.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 3/24/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import UIKit

class NextFourPhasesViewController: UIViewController, UIUpdatable
{
    private var delegate: UIUpdatable?
    private let moonPhaseDateTimeFormatter = DateFormatter()
    private let moonPhaseIcons = [
        "new_moon": #imageLiteral(resourceName: "New-Moon"),
        "first_quarter": #imageLiteral(resourceName: "FQ-Moon"),
        "full_moon": #imageLiteral(resourceName: "Full-Moon"),
        "last_quarter": #imageLiteral(resourceName: "TQ-Moon")
    ]
    
    @IBOutlet weak var firstPhaseImage: UIImageView!
    @IBOutlet weak var firstPhaseDateLabel: UILabel!
    @IBOutlet weak var secondPhaseImage: UIImageView!
    @IBOutlet weak var secondPhaseDateLabel: UILabel!
    @IBOutlet weak var thirdPhaseImage: UIImageView!
    @IBOutlet weak var thirdPhaseDateLabel: UILabel!
    @IBOutlet weak var fourthPhaseImage: UIImageView!
    @IBOutlet weak var fourthPhaseDateLabel: UILabel!
    
    override func viewDidLoad() {
        delegate = self
        super.viewDidLoad()
        setupMoonPhaseDateTimeFormatter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    private func setupMoonPhaseDateTimeFormatter() {
        moonPhaseDateTimeFormatter.dateFormat = MoonInfoConstants.minutesTimeWithTimeZone
        moonPhaseDateTimeFormatter.timeZone = MoonInfoConstants.localTimeZone
    }
    
    private func formatPhaseInfo(phase: (String, Date), image: UIImageView, label: UILabel) {
        image.image = moonPhaseIcons[phase.0]
        label.text = moonPhaseDateTimeFormatter.string(from: phase.1)
    }
    
    func updateUI() {
        if view != nil {
            if let mipvc = parent as? MoonInfoPageViewController {
                if let moonInfo = mipvc.moonInfo {
                    formatPhaseInfo(phase: moonInfo.getPhase(index: 0), image: firstPhaseImage, label: firstPhaseDateLabel)
                    formatPhaseInfo(phase: moonInfo.getPhase(index: 1), image: secondPhaseImage, label: secondPhaseDateLabel)
                    formatPhaseInfo(phase: moonInfo.getPhase(index: 2), image: thirdPhaseImage, label: thirdPhaseDateLabel)
                    formatPhaseInfo(phase: moonInfo.getPhase(index: 3), image: fourthPhaseImage, label: fourthPhaseDateLabel)
                }
            }
        }
    }
}
