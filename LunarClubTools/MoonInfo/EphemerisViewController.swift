//
//  EphemerisViewController.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 6/12/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import UIKit

class EphemerisViewController: UITableViewController, UIUpdatable
{
    private var delegate: UIUpdatable?
    private let formatter = NumberFormatter()
    private let localDateTimeFormatter = DateFormatter()
    private let utcDateTimeFormatter = DateFormatter()
    
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var localDateLabel: UILabel!
    @IBOutlet weak var localDateTime: UILabel!
    @IBOutlet weak var utcDateTime: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var phase: UILabel!
    @IBOutlet weak var illumination: UILabel!
    @IBOutlet weak var colongitude: UILabel!
    @IBOutlet weak var elongation: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var angularSize: UILabel!
    @IBOutlet weak var magnitude: UILabel!
    
    override func viewDidLoad() {
        delegate = self
        super.viewDidLoad()
        setupFormatter()
        setupLocalDateTimeFormatter()
        setupUtcDateTimeFormatter()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
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
        let minutesDouble = (fabs(coordinate!) - Double(degrees)) * 60.0
        
        var coordinateString = "\(degrees)\(MoonInfoConstants.degrees) " + formatter.string(from: minutesDouble as NSNumber)! + "'"
        
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 11
        default:
            return 0
        }
    }

    func updateUI() {
        if view != nil {
            if let mipvc = parent as? MoonInfoPageViewController {
                if let moonInfo = mipvc.moonInfo {

                    let timeZoneString = localDateTimeFormatter.timeZone.abbreviation() ?? ""
                    if timeZoneString != "" {
                        localDateLabel.text =  "Date (" + timeZoneString + ")"
                    }
                    
                    var haveGoodLocation : Bool
                    if let lo = mipvc.isLocationOK {
                        haveGoodLocation = lo
                    } else {
                        let tbc = mipvc.tabBarController as! LunarClubToolsTabBarController
                        haveGoodLocation = tbc.timeAndLocation.getLocationStatus()
                    }

                    if let ct = mipvc.currentTime {
                        localDateTime.text = localDateTimeFormatter.string(from: ct)
                        utcDateTime.text = utcDateTimeFormatter.string(from: ct)
                    } else {
                        let tbc = mipvc.tabBarController as! LunarClubToolsTabBarController
                        localDateTime.text = localDateTimeFormatter.string(from: tbc.timeAndLocation.getCurrentTime())
                        utcDateTime.text = utcDateTimeFormatter.string(from: tbc.timeAndLocation.getCurrentTime())
                    }
                    age.text = formatDoubleLabel(value: moonInfo.age, backCaption: " days")
                    illumination.text = formatDoubleLabel(value: moonInfo.illumination, backCaption: "%")
                    colongitude.text = formatCoordinateLabel(from: moonInfo.colongitude, direction: nil)
                    elongation.text = formatCoordinateLabel(from: moonInfo.elongation, direction: nil)
                    if let cc = mipvc.currentLocation {
                        let latitude = formatCoordinateLabel(from: cc.latitude, direction: "N S")
                        let longitude = formatCoordinateLabel(from: cc.longitude, direction: "E W")
                        location.text = "\(latitude) \(longitude)"
                    } else {
                        let tbc = mipvc.tabBarController as! LunarClubToolsTabBarController
                        let coords = tbc.timeAndLocation.getCoordinates()
                        let latitude = formatCoordinateLabel(from: coords.latitude, direction: "N S")
                        let longitude = formatCoordinateLabel(from: coords.longitude, direction: "E W")
                        location.text = "\(latitude) \(longitude)"
                    }
                    phase.text = moonInfo.phaseName
                    distance.text = formatDoubleLabel(value: moonInfo.earthDistance, backCaption: " km")
                    angularSize.text = formatDoubleLabel(value: moonInfo.angularSize, backCaption: MoonInfoConstants.degrees)
                    magnitude.text = formatDoubleLabel(value: moonInfo.magnitude, backCaption: "")
                    if haveGoodLocation {
                        let normalFont = UIFont.preferredFont(forTextStyle: .title3)
                        distance.font = normalFont
                        angularSize.font = normalFont
                    } else {
                        let italicFont = UIFont.preferredFont(forTextStyle: .title3).italic()
                        distance.font = italicFont
                        angularSize.font = italicFont
                    }
                }
            }
        }
    }
}
