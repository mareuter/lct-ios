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
    
    private struct FileNames {
        static let bundleFile = "MoonInfoJSON"
        static let downloadedFile = "MoonInfo.json"
    }
    
    private var moonInfoFile: Data? {
        let fileManager = FileManager.default
        let dirs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        do {
            let fileList = try fileManager.contentsOfDirectory(at: dirs[0], includingPropertiesForKeys: nil, options: [])
            print("A: \(fileList)")
            for file in fileList {
                if file.absoluteString.contains(FileNames.downloadedFile) {
                    return try? Data(contentsOf: file)
                }
            }
        } catch let error {
            print("\(error)")
            print("Cannot read \(dirs[0].absoluteString)")
            return nil
        }

        return NSDataAsset(name: FileNames.bundleFile, bundle: Bundle.main)!.data
    }
    
    private var moonInfo : MoonInfo?
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
        formatter.minimumIntegerDigits = 1
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
    
    private func formatDoubleLabel(value: Double?, backCaption: String) -> String {
        let parameter = value ?? 0.0
        return formatter.string(from: parameter as NSNumber)! + backCaption
    }
    
    private func formatPhaseInfo(image: UIImageView, label: UILabel, index: Int) {
        if let phase = moonInfo?.getPhase(index: index) {
            image.image = moonPhaseIcons[phase.0]
            label.text = moonPhaseDateTimeFormatter.string(from: phase.1)
        }
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
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moonInfo = MoonInfo(jsonFile: moonInfoFile!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        moonInfo = MoonInfo(jsonFile: moonInfoFile!)
    }
    
    private func fetchData() {
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
        spinner?.startAnimating()
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            if statusCode == 200 {
                //print("Downloaded Moon Info")
                let fileManager = FileManager.default
                let dirs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
                let fileName = dirs[0].appendingPathComponent("MoonInfo.json")
                print("\(dirs)")
                let x = try? data?.write(to: fileName)
                if x == nil {
                    print("Failed to write file.")
                } else {
                    print("OK")
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
        localDateInfo.text = localDateTimeFormatter.string(from: timeAndLocation.getCurrentTime())
        utcDateInfo.text = utcDateTimeFormatter.string(from: timeAndLocation.getCurrentTime())
        ageInfo.text = formatDoubleLabel(value: moonInfo?.age, backCaption: " days")
        illuminationInfo.text = formatDoubleLabel(value: moonInfo?.illumination, backCaption: "%")
        colongitudeInfo.text = formatDoubleLabel(value: moonInfo?.colongitude, backCaption: Symbols.degrees)
        librationLatitudeInfo.text = formatDoubleLabel(value: moonInfo?.librationLatitude, backCaption: Symbols.degrees)
        librationLongitudeInfo.text = formatDoubleLabel(value: moonInfo?.librationLongitude, backCaption: Symbols.degrees)
        altitudeInfo.text = formatDoubleLabel(value: moonInfo?.altitude, backCaption: Symbols.degrees)
        azimuthInfo.text = formatDoubleLabel(value: moonInfo?.azimuth, backCaption: Symbols.degrees)
        formatPhaseInfo(image: firstPhaseImage, label: firstPhaseLabel, index: 0)
        formatPhaseInfo(image: secondPhaseImage, label: secondPhaseLabel, index: 1)
        formatPhaseInfo(image: thirdPhaseImage, label: thirdPhaseLabel, index: 2)
        formatPhaseInfo(image: fourthPhaseImage, label: fourthPhaseLabel, index: 3)
        spinner?.stopAnimating()
    }
}

