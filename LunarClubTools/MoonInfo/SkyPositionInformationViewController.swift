//
//  SkyPositionInformationViewController.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 6/8/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import UIKit

class SkyPositionInformationViewController: UITableViewController, UIUpdatable
{
    private var delegate: UIUpdatable?
    private let formatter = NumberFormatter()
    private let timeFormatter = DateFormatter()
    
    @IBOutlet weak var altitudeInfo: UILabel!
    @IBOutlet weak var azimuthInfo: UILabel!
    @IBOutlet weak var rightAscensionInfo: UILabel!
    @IBOutlet weak var declinationInfo: UILabel!
    @IBOutlet weak var riseTime: UILabel!
    @IBOutlet weak var transitTime: UILabel!
    @IBOutlet weak var setTime: UILabel!
   
    
    override func viewDidLoad() {
        delegate = self
        super.viewDidLoad()
        setupFormatter()
        setupTimeFormatter()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    private func setupFormatter() {
        formatter.minimumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
    }
    
    private func setupTimeFormatter() {
        timeFormatter.dateFormat = MoonInfoConstants.timeOnly
    }
    
    private func formatDoubleLabel(value: Double?, backCaption: String) -> String {
        let parameter = value ?? 0.0
        return formatter.string(from: parameter as NSNumber)! + backCaption
    }
    
    private func getTime(from time: Any?) -> String {
        var output: String
        if let datetime = time as? Array<Int> {
            let dc = DateComponents(calendar: (NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)! as Calendar),
                                    year: datetime[0], month: datetime[1], day: datetime[2],
                                    hour: datetime[3], minute: datetime[4], second: datetime[5])
            output = timeFormatter.string(from: dc.date!)
        } else {
            output = LunarClubConstants.timeLabelDefaultText
        }
        
        return output
    }
    
    private func formatRightAscension(from ra: Double) -> String {
        let hourDecimal = ra / 15.0
        let hours = Int(hourDecimal)
        let minutesDecimal = (hourDecimal - Double(hours)) * 60.0
        let minutes = Int(minutesDecimal)
        return String(format: "%02dh %02dm", hours, minutes)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func updateUI() {
        if view != nil {
            if let mipvc = parent as? MoonInfoPageViewController {
                if let moonInfo = mipvc.moonInfo {

                    var haveGoodLocation : Bool
                    if let lo = mipvc.isLocationOK {
                        haveGoodLocation = lo
                    } else {
                        let tbc = mipvc.tabBarController as! LunarClubToolsTabBarController
                        haveGoodLocation = tbc.timeAndLocation.getLocationStatus()
                    }
                    
                    altitudeInfo.text = formatDoubleLabel(value: moonInfo.altitude, backCaption: MoonInfoConstants.degrees)
                    azimuthInfo.text = formatDoubleLabel(value: moonInfo.azimuth, backCaption: MoonInfoConstants.degrees)
                    rightAscensionInfo.text = formatRightAscension(from: moonInfo.rightAscension)
                    declinationInfo.text = formatDoubleLabel(value: moonInfo.declination, backCaption: MoonInfoConstants.degrees)
                    riseTime.text = getTime(from: moonInfo.riseTime)
                    transitTime.text = getTime(from: moonInfo.transitTime)
                    setTime.text = getTime(from: moonInfo.setTime)

                    if haveGoodLocation {
                        let normalFont = UIFont.preferredFont(forTextStyle: .title3)
                        altitudeInfo.font = normalFont
                        azimuthInfo.font = normalFont
                        rightAscensionInfo.font = normalFont
                        declinationInfo.font = normalFont
                        riseTime.font = normalFont
                        transitTime.font = normalFont
                        setTime.font = normalFont
                    } else {
                        let italicFont = UIFont.preferredFont(forTextStyle: .title3).italic()
                        altitudeInfo.font = italicFont
                        azimuthInfo.font = italicFont
                        rightAscensionInfo.font = italicFont
                        declinationInfo.font = italicFont
                        riseTime.font = italicFont
                        transitTime.font = italicFont
                        setTime.font = italicFont
                    }
                }
            }
        }
    }
}
