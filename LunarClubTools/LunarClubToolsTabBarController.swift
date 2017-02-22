//
//  LunarClubToolsTabBarController.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 2/14/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import UIKit
import CoreLocation

class LunarClubToolsTabBarController: UITabBarController, CLLocationManagerDelegate {

    var timeAndLocation = TimeAndLocation()
    private var locationManager : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        determineMyLocation()
    }

    private func determineMyLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        manager.stopUpdatingLocation()
        timeAndLocation.updateCoordinates(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        print("Location: (\(userLocation.coordinate.latitude), \(userLocation.coordinate.longitude))")
        for vc in viewControllers! {
            vc.viewWillAppear(true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    
}
