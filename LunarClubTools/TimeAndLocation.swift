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
    private var currentTime: Date {
        get {
            return UserDefaults.standard.object(forKey: ProgramConstants.dateTimeKey) as? Date ?? Date()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ProgramConstants.dateTimeKey)
        }
    }
    private var currentLongitude: Double {
        get {
            return UserDefaults.standard.double(forKey: ProgramConstants.longitudeKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ProgramConstants.longitudeKey)
        }
    }
    private var currentLatitude: Double {
        get {
            return UserDefaults.standard.double(forKey: ProgramConstants.latitudeKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ProgramConstants.latitudeKey)
        }
    }
    
    func getCurrentTime() -> Date {
        return currentTime
    }
    
    func getTimestamp() -> TimeInterval {
        return currentTime.timeIntervalSince1970
    }
    
    func getCoordinates() -> (latitude: Double, longitude: Double) {
        return (currentLatitude, currentLongitude)
    }
    
    func updateCoordinates(latitude: Double, longitude: Double) {
        currentLatitude = latitude
        currentLongitude = longitude
    }
    
    func updateTime(new date: Date) {
        currentTime = date
    }
}
