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
    
    init?(jsonFile: Data) {
        //print(String(data: jsonFile, encoding: String.Encoding.utf8) ?? "Cannot print data")
        let json = try! JSONSerialization.jsonObject(with: jsonFile, options: []) as! [String: Any]
        
        guard let timeFromNewMoon = json["time_from_new_moon"] as? Double,
            let timeToNewMoon = json["time_to_new_moon"] as? Double,
            let timeToFullMoon = json["time_to_full_moon"] as? Double
        else {
            return nil
        }
    
        self.timeToNewMoon = timeToNewMoon
        self.timeFromNewMoon = timeFromNewMoon
        self.timeToFullMoon = timeToFullMoon
    }
}
