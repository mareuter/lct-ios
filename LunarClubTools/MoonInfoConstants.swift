//
//  MoonInfoConstants.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 3/27/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import Foundation

struct MoonInfoConstants
{
    static let topLevelStoryBoard = "Main"
    static let ephemerisVcName = "EphemerisViewController"
    static let nextFourPhasesVcName = "NextFourPhasesViewController"
    static let secondsTime = "yyyy-MM-dd HH:mm:ss"
    static let minutesTimeWithTimeZone = "yyyy-MM-dd HH:mm zzz"
    static let localTimeZone = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)?.timeZone
    static let utcTimeZone = TimeZone(abbreviation: "GMT")
    static let degrees = "°"
}