//
//  MoonInfoViewController.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 1/8/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import UIKit
import Foundation

class MoonInfoViewController: UIViewController {

    var moonInfo = MoonInfo(age: 14.184, colongitude: 87.519, fractionalPhase: 0.999428, librationLatitude: -1.0329,
                            librationLongitude: 5.18859, altitude: 64.3990, azimuth: 161.7587,
                            nextFourPhases: [("tq", [2013, 10, 26, 23, 40, 29]), ("new", [2013, 11, 3, 12, 49, 58]),
                                             ("fq", [2013, 11, 10, 5, 57, 10]), ("full", [2013, 11, 17, 15, 15, 44])])
    {
        didSet {
            updateUI()
        }
    }
    
    private let formatter = NumberFormatter()
    private let localDateTimeFormatter = DateFormatter()
    private let utcDateTimeFormatter = DateFormatter()
    private let moonPhaseDateTimeFormatter = DateFormatter()
    
    private let moonPhaseIcons = [
        "new": #imageLiteral(resourceName: "New-Moon"),
        "fq": #imageLiteral(resourceName: "FQ-Moon"),
        "full": #imageLiteral(resourceName: "Full-Moon"),
        "tq": #imageLiteral(resourceName: "TQ-Moon")
    ]
    
    private struct TimeConstants {
        static let secondsTime = "yyyy-MM-dd HH:mm:ss"
        static let minutesTimeWithTimeZone = "yyyy-MM-dd HH:mm zzz"
        static let localTimeZone = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)?.timeZone
        static let utcTimeZone = NSTimeZone(abbreviation: "GMT") as? TimeZone
    }
    
    private struct Symbols {
        static let degrees = "°"
    }
    
    private func setupFormatter() {
        formatter.minimumFractionDigits = 2
    }
    
    private func setupLocalDateTimeFormatter() {
        localDateTimeFormatter.dateFormat = TimeConstants.secondsTime
        localDateTimeFormatter.locale = NSLocale.current
        localDateTimeFormatter.timeZone = TimeConstants.localTimeZone
    }
    
    private func setupMoonPhaseDateTimeFormatter() {
        moonPhaseDateTimeFormatter.dateFormat = TimeConstants.minutesTimeWithTimeZone
        moonPhaseDateTimeFormatter.timeZone = TimeConstants.localTimeZone
    }
    
    private func setupUtcDateTimeFormatter() {
        utcDateTimeFormatter.dateFormat = TimeConstants.secondsTime
        utcDateTimeFormatter.timeZone = TimeConstants.utcTimeZone
    }
    
    private func formatDoubleLabel(label: UILabel, value: Double, backCaption: String) -> String {
        return label.text! + " " + formatter.string(from: value as NSNumber)! + backCaption
    }
    
    private func formatPhaseInfo(image: UIImageView, label: UILabel, index: Int) {
        let phase = moonInfo.getPhase(index: index)
        image.image = moonPhaseIcons[phase.0]
        label.text = moonPhaseDateTimeFormatter.string(from: phase.1)
    }
    
    @IBOutlet weak private var localDateLabel: UILabel!
    @IBOutlet weak private var localDateInfo: UILabel!
    @IBOutlet weak private var utcDateInfo: UILabel!
    @IBOutlet weak private var ageInfo: UILabel!
    @IBOutlet weak private var illuminationInfo: UILabel!
    @IBOutlet weak private var colongitudeInfo: UILabel!
    @IBOutlet weak private var librationLatitudeInfo: UILabel!
    @IBOutlet weak private var librationLongitudeInfo: UILabel!
    @IBOutlet weak private var altitudeInfo: UILabel!
    @IBOutlet weak private var azimuthInfo: UILabel!
    
    @IBOutlet weak private var firstPhaseImage: UIImageView!
    @IBOutlet weak private var firstPhaseLabel: UILabel!
    @IBOutlet weak private var secondPhaseImage: UIImageView!
    @IBOutlet weak private var secondPhaseLabel: UILabel!
    @IBOutlet weak private var thirdPhaseImage: UIImageView!
    @IBOutlet weak private var thirdPhaseLabel: UILabel!
    @IBOutlet weak private var fourthPhaseImage: UIImageView!
    @IBOutlet weak private var fourthPhaseLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        setupFormatter()
        setupLocalDateTimeFormatter()
        setupUtcDateTimeFormatter()
        setupMoonPhaseDateTimeFormatter()
        let timeZoneString = localDateTimeFormatter.timeZone.abbreviation() ?? ""
        if timeZoneString != "" {
            localDateLabel.text = localDateLabel.text! + " (" + timeZoneString + ")"
        }
        let now = NSDate() as Date
        localDateInfo.text = localDateTimeFormatter.string(from: now)
        utcDateInfo.text = utcDateTimeFormatter.string(from: now)
        ageInfo.text = formatDoubleLabel(label: ageInfo, value: moonInfo.age, backCaption: " days")
        illuminationInfo.text = formatDoubleLabel(label: illuminationInfo, value: moonInfo.illumination, backCaption: "%")
        colongitudeInfo.text = formatDoubleLabel(label: colongitudeInfo, value: moonInfo.colongitude, backCaption: Symbols.degrees)
        librationLatitudeInfo.text = formatDoubleLabel(label: librationLatitudeInfo, value: moonInfo.librationLatitude, backCaption: Symbols.degrees)
        librationLongitudeInfo.text = formatDoubleLabel(label: librationLongitudeInfo, value: moonInfo.librationLongitude, backCaption: Symbols.degrees)
        altitudeInfo.text = formatDoubleLabel(label: altitudeInfo, value: moonInfo.altitude, backCaption: Symbols.degrees)
        azimuthInfo.text = formatDoubleLabel(label: azimuthInfo, value: moonInfo.azimuth, backCaption: Symbols.degrees)
        formatPhaseInfo(image: firstPhaseImage, label: firstPhaseLabel, index: 0)
        formatPhaseInfo(image: secondPhaseImage, label: secondPhaseLabel, index: 1)
        formatPhaseInfo(image: thirdPhaseImage, label: thirdPhaseLabel, index: 2)
        formatPhaseInfo(image: fourthPhaseImage, label: fourthPhaseLabel, index: 3)
    }
}

