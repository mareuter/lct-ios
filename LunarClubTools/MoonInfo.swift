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
        components.timeZone = NSTimeZone(abbreviation: "GMT") as? TimeZone
        let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let cdate = cal?.date(from: components as DateComponents)
        return (phaseId, cdate!)
    }
}
