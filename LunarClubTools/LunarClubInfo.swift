//
//  LunarClubInfo.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 4/26/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import Foundation

struct LunarClubInfo
{
    let timeFromNewMoon: Double
    let timeToNewMoon: Double
    let timeToFullMoon: Double
    let fractionalPhase: Double
    
    init?(jsonFile: Data) {
        //print(String(data: jsonFile, encoding: String.Encoding.utf8) ?? "Cannot print data")
        var json: [String: Any]? = nil
        do {
            json = try JSONSerialization.jsonObject(with: jsonFile, options: []) as? [String: Any]
        } catch {
            return nil
        }
        
        guard let timeFromNewMoon = json!["time_from_new_moon"] as? Double,
            let timeToNewMoon = json!["time_to_new_moon"] as? Double,
            let timeToFullMoon = json!["time_to_full_moon"] as? Double,
            let fractionalPhase = json!["fractional_phase"] as? Double
        else {
            return nil
        }
    
        self.timeToNewMoon = timeToNewMoon
        self.timeFromNewMoon = timeFromNewMoon
        self.timeToFullMoon = timeToFullMoon
        self.fractionalPhase = fractionalPhase
    }
}
