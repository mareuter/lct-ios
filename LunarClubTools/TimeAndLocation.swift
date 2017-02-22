//
//  TimeAndLocation.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 2/19/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import Foundation

class TimeAndLocation
{
    private var currentTime = NSDate()
    private var currentLongitude = -84.316666666666
    private var currentLatitude = 35.9694444444444
    
    func getCurrentTime() -> NSDate {
        return currentTime
    }
    
    func getTimestamp() -> TimeInterval {
        return currentTime.timeIntervalSince1970
    }
    
    func getCoordinates() -> (latitude: Double, longitude: Double) {
        return (currentLatitude, currentLongitude)
    }
}
