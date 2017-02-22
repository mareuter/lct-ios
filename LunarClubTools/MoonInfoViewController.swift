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
    
    var moonInfo = MoonInfo(jsonFile: NSDataAsset(name: "MoonInfoJSON", bundle: Bundle.main)!.data)!
    {
        didSet {
            updateUI()
        }
    }
    
    private let formatter = NumberFormatter()
    private let localDateTimeFormatter = DateFormatter()
    private let utcDateTimeFormatter = DateFormatter()
    private let moonPhaseDateTimeFormatter = DateFormatter()
    private var urlComp = URLComponents()
    private var timeAndLocation = TimeAndLocation()
    
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
    
    private func setupMoonInfoUrl() -> URLComponents {
        urlComp.scheme = "https"
        urlComp.host = "lct-web.herokuapp.com"
        urlComp.path = "/moon_info"
        return urlComp
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
    
    private func formatDoubleLabel(value: Double, backCaption: String) -> String {
        return formatter.string(from: value as NSNumber)! + backCaption
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tbc = tabBarController as! LunarClubToolsTabBarController
        timeAndLocation = tbc.timeAndLocation
        let coords = timeAndLocation.getCoordinates()
        var url = setupMoonInfoUrl()
        let dateQuery = URLQueryItem(name: "date", value: String(timeAndLocation.getTimestamp()))
        let longitudeQuery = URLQueryItem(name: "lon", value: String(coords.longitude))
        let latitudeQuery = URLQueryItem(name: "lat", value: String(coords.latitude))
        url.queryItems = [dateQuery, latitudeQuery, longitudeQuery]
        let session = URLSession(configuration: URLSessionConfiguration.default)
        //print(url.url!)
        let request = URLRequest(url: url.url!)
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            if statusCode == 200 {
                //print("Downloaded Moon Info")
                DispatchQueue.main.async {
                    self.moonInfo = MoonInfo(jsonFile: data!)!
                }
            } else {
                print("Download failed: \(statusCode)")
            }
        }
        task.resume()
    }
    
    private func updateUI() {
        setupFormatter()
        setupLocalDateTimeFormatter()
        setupUtcDateTimeFormatter()
        setupMoonPhaseDateTimeFormatter()
        let timeZoneString = localDateTimeFormatter.timeZone.abbreviation() ?? ""
        if timeZoneString != "" {
            localDateLabel.text =  "Date (" + timeZoneString + ")"
        }
        localDateInfo.text = localDateTimeFormatter.string(from: timeAndLocation.getCurrentTime() as Date)
        utcDateInfo.text = utcDateTimeFormatter.string(from: timeAndLocation.getCurrentTime() as Date)
        ageInfo.text = formatDoubleLabel(value: moonInfo.age, backCaption: " days")
        illuminationInfo.text = formatDoubleLabel(value: moonInfo.illumination, backCaption: "%")
        colongitudeInfo.text = formatDoubleLabel(value: moonInfo.colongitude, backCaption: Symbols.degrees)
        librationLatitudeInfo.text = formatDoubleLabel(value: moonInfo.librationLatitude, backCaption: Symbols.degrees)
        librationLongitudeInfo.text = formatDoubleLabel(value: moonInfo.librationLongitude, backCaption: Symbols.degrees)
        altitudeInfo.text = formatDoubleLabel(value: moonInfo.altitude, backCaption: Symbols.degrees)
        azimuthInfo.text = formatDoubleLabel(value: moonInfo.azimuth, backCaption: Symbols.degrees)
        formatPhaseInfo(image: firstPhaseImage, label: firstPhaseLabel, index: 0)
        formatPhaseInfo(image: secondPhaseImage, label: secondPhaseLabel, index: 1)
        formatPhaseInfo(image: thirdPhaseImage, label: thirdPhaseLabel, index: 2)
        formatPhaseInfo(image: fourthPhaseImage, label: fourthPhaseLabel, index: 3)
    }
}

