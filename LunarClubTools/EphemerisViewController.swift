//
//  EphemerisViewController.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 6/12/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import UIKit

class EphemerisViewController: UITableViewController, UIUpdatable {

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
            return 9
        default:
            return 0
        }
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
                    localDateTime.text = localDateTimeFormatter.string(from: tl.getCurrentTime())
                    utcDateTime.text = utcDateTimeFormatter.string(from: tl.getCurrentTime())
                    age.text = formatDoubleLabel(value: moonInfo.age, backCaption: " days")
                    illumination.text = formatDoubleLabel(value: moonInfo.illumination, backCaption: "%")
                    colongitude.text = formatCoordinateLabel(from: moonInfo.colongitude, direction: nil)
                    elongation.text = formatCoordinateLabel(from: moonInfo.elongation, direction: nil)
                    let latitude = formatCoordinateLabel(from: tl.getCoordinates().latitude, direction: "N S")
                    let longitude = formatCoordinateLabel(from: tl.getCoordinates().longitude, direction: "E W")
                    location.text = "\(latitude) \(longitude)"
                    phase.text = moonInfo.phaseName
                    distance.text = formatDoubleLabel(value: moonInfo.earthDistance, backCaption: " km")
                }
            }
        }
    }
}
