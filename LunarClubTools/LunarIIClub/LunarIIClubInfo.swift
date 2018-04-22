//
//  LunarIIClubInfo.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 5/30/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import Foundation

struct LunarIIClubInfo
{
    lazy var features: Array<LunarFeature> = []
    lazy var landingSites: Array<LunarFeature> = []
    
    init?(jsonFile: Data) {
        //print(String(data: jsonFile, encoding: String.Encoding.utf8) ?? "Cannot print data")
        var json: [String: Any]? = nil
        do {
            json = try JSONSerialization.jsonObject(with: jsonFile, options: []) as? [String: Any]
        } catch {
            return nil
        }
        
        guard let featuresJSON = json!["features"] as? [String: Any],
            let landingSitesJSON = json!["landing_sites"] as? [String: Any]
            else {
                return nil
        }
        
        self.features = fillOutFeatureLists(from: featuresJSON)
        self.landingSites = fillOutFeatureLists(from: landingSitesJSON)
    }
    
    private func fillOutFeatureLists(from json: [String: Any]) -> Array<LunarFeature> {
        var newFeatureList: Array<LunarFeature> = []
        for featureList in Array(json.values) {
            if let featureInfo = featureList as? Array<Any> {
                newFeatureList.append(LunarFeature(name: (featureInfo[0] as? String)!,
                                                   latitude: (featureInfo[2] as? Double)!,
                                                   longitude: (featureInfo[3] as? Double)!,
                                                   type: (featureInfo[6] as? String)!,
                                                   diameter: (featureInfo[1] as? Double)!,
                                                   quadName: (featureInfo[7] as? String)!,
                                                   quadCode: (featureInfo[8] as? String)!))
            }
        }
        newFeatureList.sort { $0.latitude > $1.latitude }
        return newFeatureList
    }
}
