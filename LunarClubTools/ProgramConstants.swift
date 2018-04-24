//
//  ProgramConstants.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 3/30/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import Foundation

struct ProgramConstants
{
    static let webServiceUrl = Bundle.main.infoDictionary?["WEB_SERVICE_URL"] as? String
    static let changeTimeNotification = Notification.Name("ChangeTimeNotification")
    static let changeTimeSegue = "Change Time"
    static let requestFailedTitle = "Request Failed"
    static let jsonReadFailedTitle = "JSON Read Failed"
    static let locationUpdateFailedTitle = "Location Update Failed"
    static let topLevelStoryBoard = "Main"
    static let dateTimeKey = "DateTime"
    static let latitudeKey = "Latitude"
    static let longitudeKey = "Longitude"
}
