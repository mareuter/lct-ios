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
    lazy var nakedEyeFeatures: Array<LunarFeature> = []
    lazy var binocularFeatures: Array<LunarFeature> = []
    lazy var telescopeFeatures: Array<LunarFeature> = []
    
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
            let fractionalPhase = json!["fractional_phase"] as? Double,
            let nakedEyeFeaturesJSON = json!["naked_eye_features"] as? [String: Any],
            let binocularFeaturesJSON = json!["binocular_features"] as? [String: Any],
            let telescopeFeaturesJSON = json!["telescope_features"] as? [String: Any]
        else {
            return nil
        }
        
        self.timeToNewMoon = timeToNewMoon
        self.timeFromNewMoon = timeFromNewMoon
        self.timeToFullMoon = timeToFullMoon
        self.fractionalPhase = fractionalPhase
        self.nakedEyeFeatures = fillOutFeatureLists(from: nakedEyeFeaturesJSON)
        self.binocularFeatures = fillOutFeatureLists(from: binocularFeaturesJSON)
        self.telescopeFeatures = fillOutFeatureLists(from: telescopeFeaturesJSON)
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
