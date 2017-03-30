//
//  EphemerisViewController.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 3/24/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import UIKit

class EphemerisViewController: UIViewController, UIUpdatable {

    private var delegate: UIUpdatable?
    private let formatter = NumberFormatter()
    private let localDateTimeFormatter = DateFormatter()
    private let utcDateTimeFormatter = DateFormatter()
    
    @IBOutlet weak var ageInfo: UILabel!
    @IBOutlet weak var phaseInfo: UILabel!
    @IBOutlet weak var illuminationInfo: UILabel!
    @IBOutlet weak var colongitudeInfo: UILabel!
    @IBOutlet weak var localDateLabel: UILabel!
    @IBOutlet weak var localDateInfo: UILabel!
    @IBOutlet weak var utcDateInfo: UILabel!
    @IBOutlet weak var latitudeInfo: UILabel!
    @IBOutlet weak var longitudeInfo: UILabel!
    
    override func viewDidLoad() {
        delegate = self
        super.viewDidLoad()
        setupFormatter()
        setupLocalDateTimeFormatter()
        setupUtcDateTimeFormatter()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    private func setupFormatter() {
        formatter.minimumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
    }
    
    private func setupLocalDateTimeFormatter() {
        localDateTimeFormatter.dateFormat = MoonInfoConstants.secondsTime
        localDateTimeFormatter.locale = NSLocale.current
        localDateTimeFormatter.timeZone = MoonInfoConstants.localTimeZone
    }
    
    private func setupUtcDateTimeFormatter() {
        utcDateTimeFormatter.dateFormat = MoonInfoConstants.secondsTime
        utcDateTimeFormatter.timeZone = MoonInfoConstants.utcTimeZone
    }
    
    private func formatDoubleLabel(value: Double?, backCaption: String) -> String {
        let parameter = value ?? 0.0
        return formatter.string(from: parameter as NSNumber)! + backCaption
    }

    private func formatCoordinateLabel(from coordinate: Double?, direction label: String?) -> String {
        let degrees = Int(fabs(coordinate!))
        let minDouble = (fabs(coordinate!) - Double(degrees)) * 60.0
        let minutes = Int(minDouble)
        let secDouble = (minDouble - Double(minutes)) * 60.0
        let seconds = Int(secDouble)
        
        var coordinateString = "\(degrees)\(MoonInfoConstants.degrees) \(minutes)' \(seconds)\""
        
        if label != nil {
            let cardinalDirs = label!.components(separatedBy: " ")
            if coordinate! < 0 {
                coordinateString += " \(cardinalDirs.last!)"
            } else {
                coordinateString += " \(cardinalDirs.first!)"
            }
        }
        
        return coordinateString
    }
    
    func updateUI() {
        if view != nil {
            if let mipvc = parent as? MoonInfoPageViewController {
                if let moonInfo = mipvc.moonInfo {
                    let tl = mipvc.timeAndLocation
                    let timeZoneString = localDateTimeFormatter.timeZone.abbreviation() ?? ""
                    if timeZoneString != "" {
                        localDateLabel.text =  "Date (" + timeZoneString + ")"
                    }
                    localDateInfo.text = localDateTimeFormatter.string(from: tl.getCurrentTime())
                    utcDateInfo.text = utcDateTimeFormatter.string(from: tl.getCurrentTime())
                    ageInfo.text = formatDoubleLabel(value: moonInfo.age, backCaption: " days")
                    illuminationInfo.text = formatDoubleLabel(value: moonInfo.illumination, backCaption: "%")
                    colongitudeInfo.text = formatCoordinateLabel(from: moonInfo.colongitude, direction: nil)
                    latitudeInfo.text = formatCoordinateLabel(from: tl.getCoordinates().latitude, direction: "N S")
                    longitudeInfo.text = formatCoordinateLabel(from: tl.getCoordinates().longitude, direction: "E W")
                }
            }
        }
    }
}

