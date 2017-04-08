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
        print("LCTTBC will appear")
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(forName: ProgramConstants.changeTimeNotification,
                                               object: nil, queue: nil, using: updateTime)
        determineMyLocation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("LCTTBC will disappear")
    }
    
    private func updateTime(notification: Notification) -> Void {
        guard let userInfo = notification.userInfo,
            let date = userInfo["date"] as? Date else {
                return
        }
        print("LCTTBC \(date)")
        timeAndLocation.updateTime(new: date)
        makeVcsFetchData()
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
    
    private func makeVcsFetchData() {
        for vc in viewControllers! {
            if let fd = vc.contents as? FetchableData {
                fd.fetchData()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        manager.stopUpdatingLocation()
        timeAndLocation.updateCoordinates(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        print("Location: (\(userLocation.coordinate.latitude), \(userLocation.coordinate.longitude))")
        makeVcsFetchData()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
}

extension UIViewController
{
    // a friendly var we've added to UIViewController
    // it returns the "contents" of this UIViewController
    // which, if this UIViewController is a UINavigationController
    // means "the UIViewController contained in me (and visible)"
    // otherwise, it just means the UIViewController itself
    // could easily imagine extending this for UITabBarController too
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}
