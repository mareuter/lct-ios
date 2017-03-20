//
//  MoonInfo.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 1/16/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import Foundation

struct MoonInfo
{
    let age: Double
    let colongitude: Double
    let fractionalPhase: Double
    let librationLatitude: Double
    let librationLongitude: Double
    let altitude: Double
    let azimuth: Double
    let nextFourPhases: Array<(String, Array<Int>)>
    
    init?(jsonFile: Data) {
        //print(String(data: jsonFile, encoding: String.Encoding.utf8) ?? "Cannot print data")
        let json = try! JSONSerialization.jsonObject(with: jsonFile, options: []) as! [String: Any]
        
        guard let age = json["age"] as? Double,
            let colongitude = json["colong"] as? Double,
            let fractionalPhase = json["fractional_phase"] as? Double,
            let librationLatitude = json["libration_lat"] as? Double,
            let librationLongitude = json["libration_lon"] as? Double,
            let altitude = json["altitude"] as? Double,
            let azimuth = json["azimuth"] as? Double,
            let nextFourPhasesJSON = json["next_four_phases"] as? [String: [String: Any]]
        else {
            return nil
        }
        
        var nextFourPhases: Array<(String, Array<Int>)> = []
        for phaseId in Array(nextFourPhasesJSON.keys).sorted(by: <) {
            if let phaseInfo = nextFourPhasesJSON[phaseId] {
                nextFourPhases.append(((phaseInfo["phase"] as? String)!, (phaseInfo["datetime"] as? Array<Int>)!))
            }
        }
        
        self.age = age
        self.colongitude = colongitude
        self.fractionalPhase = fractionalPhase
        self.librationLatitude = librationLatitude
        self.librationLongitude = librationLongitude
        self.altitude = altitude
        self.azimuth = azimuth
        self.nextFourPhases = nextFourPhases
    }
    
    var illumination: Double {
        return fractionalPhase * 100.0
    }

    func getPhase(index: Int) -> (String, Date) {
        let phaseId = nextFourPhases[index].0
        let dateList = nextFourPhases[index].1
        let components = NSDateComponents()
        components.year = dateList[0]
        components.month = dateList[1]
        components.day = dateList[2]
        components.hour = dateList[3]
        components.minute = dateList[4]
        components.second = dateList[5]
        components.timeZone = TimeZone(abbreviation: "GMT")
        let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let cdate = cal?.date(from: components as DateComponents)
        return (phaseId, cdate!)
    }
}
