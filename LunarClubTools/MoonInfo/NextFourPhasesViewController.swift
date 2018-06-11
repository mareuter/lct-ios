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
        "new_moon": #imageLiteral(resourceName: "NewMoon"),
        "first_quarter": #imageLiteral(resourceName: "FirstQuarterMoon"),
        "full_moon": #imageLiteral(resourceName: "FullMoon"),
        "last_quarter": #imageLiteral(resourceName: "ThirdQuarterMoon")
    ]
    
    @IBOutlet weak var firstPhaseImage: UIImageView!
    @IBOutlet weak var firstPhaseDateLabel: UILabel!
    @IBOutlet weak var firstPhaseTimeLabel: UILabel!
    @IBOutlet weak var secondPhaseImage: UIImageView!
    @IBOutlet weak var secondPhaseDateLabel: UILabel!
    @IBOutlet weak var secondPhaseTimeLabel: UILabel!
    @IBOutlet weak var thirdPhaseImage: UIImageView!
    @IBOutlet weak var thirdPhaseDateLabel: UILabel!
    @IBOutlet weak var thirdPhaseTimeLabel: UILabel!
    @IBOutlet weak var fourthPhaseImage: UIImageView!
    @IBOutlet weak var fourthPhaseDateLabel: UILabel!
    @IBOutlet weak var fourthPhaseTimeLabel: UILabel!
    
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
    
    private func formatPhaseInfo(phase: (String, Date), image: UIImageView, dateLabel: UILabel, timeLabel: UILabel) {
        image.image = moonPhaseIcons[phase.0]
        let dateTime = moonPhaseDateTimeFormatter.string(from: phase.1).split(separator: " ", maxSplits: 1, omittingEmptySubsequences: false)
        dateLabel.text = dateTime[0].description
        timeLabel.text = dateTime[1].description
    }
    
    func updateUI() {
        if view != nil {
            if let mipvc = parent as? MoonInfoPageViewController {
                if let moonInfo = mipvc.moonInfo {
                    formatPhaseInfo(phase: moonInfo.getPhase(index: 0), image: firstPhaseImage, dateLabel: firstPhaseDateLabel, timeLabel: firstPhaseTimeLabel)
                    formatPhaseInfo(phase: moonInfo.getPhase(index: 1), image: secondPhaseImage, dateLabel: secondPhaseDateLabel, timeLabel: secondPhaseTimeLabel)
                    formatPhaseInfo(phase: moonInfo.getPhase(index: 2), image: thirdPhaseImage, dateLabel: thirdPhaseDateLabel, timeLabel: thirdPhaseTimeLabel)
                    formatPhaseInfo(phase: moonInfo.getPhase(index: 3), image: fourthPhaseImage, dateLabel: fourthPhaseDateLabel, timeLabel: fourthPhaseTimeLabel)
                }
            }
        }
    }
}
