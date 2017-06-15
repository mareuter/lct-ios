//
//  PhaseAndLibration2ViewController.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 6/12/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import UIKit
import SceneKit

class PhaseAndLibration2ViewController: UIViewController, UIUpdatable {

    private var delegate: UIUpdatable?
    private var formatter = NumberFormatter()
    private var moonViewHelper = MoonViewHelper()
    
    @IBOutlet weak var moonView: SCNView!
    @IBOutlet weak var librationLatitude: UILabel!
    @IBOutlet weak var librationLongitude: UILabel!
    @IBOutlet weak var subSolarLatitude: UILabel!
    
    override func viewDidLoad() {
        delegate = self
        super.viewDidLoad()
        setupFormatter()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    private func setupFormatter() {
        formatter.minimumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
    }
    
    private func formatDoubleLabel(value: Double, backCaption: String) -> String {
        return formatter.string(from: value as NSNumber)! + backCaption
    }
    
    func updateUI() {
        if view != nil {
            if let mipvc = parent as? MoonInfoPageViewController {
                if let moonInfo = mipvc.moonInfo {
                    let libLat = formatDoubleLabel(value: moonInfo.librationLatitude, backCaption: MoonInfoConstants.degrees)
                    let libLon = formatDoubleLabel(value: moonInfo.librationLongitude, backCaption: MoonInfoConstants.degrees)
                    let subSolLat = formatDoubleLabel(value: moonInfo.subSolarLatitude, backCaption: MoonInfoConstants.degrees)
                    librationLatitude.text = "Libration Latitude: \(libLat)"
                    librationLongitude.text = "Libration Longitude: \(libLon)"
                    subSolarLatitude.text = "SubSolar Latitude: \(subSolLat)"
                    
                    self.moonViewHelper.setAngles(moonInfo.elongation, moonInfo.librationLatitude,
                                                  moonInfo.librationLongitude, moonInfo.subSolarLatitude)
                    self.moonViewHelper.render(self.moonView)
                }
            }
        }
    }
}
