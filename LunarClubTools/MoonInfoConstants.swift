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
    static let phaseAndLibrationVcName = "PhaseAndLibrationViewController"
    static let skyPositionVcName = "SkyPositionInformationViewController"
    static let downloadedFile = "MoonInfo.json"
    static let secondsTime = "yyyy-MM-dd HH:mm:ss"
    static let minutesTimeWithTimeZone = "yyyy-MM-dd HH:mm zzz"
    static let timeOnly = "HH:mm"
    static let localTimeZone = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)?.timeZone
    static let utcTimeZone = TimeZone(abbreviation: "GMT")
    static let degrees = "°"
    // Moon View constants
    static let maxCameraZoomOut = 1.35
    static let maxCameraPosition: Float = 1.5
    static let cameraRadius: Float = 5.0
    static let sunRadius: Float = 200.0
    static let sunShineFlux = 7000.0
    static let earthShineRadius: Float = 20.0
    static let earthShineFlux = 5.0
    static let numMoonSegments = 96
    static let arrowLightFlux = 500.0
    static let arrowRadius: Float = 1.07
    static let coneOffset: Float = 0.05
    static let arrowZPosition: Float = 0.4
}
