//
//  EphemerisViewController.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 3/24/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import UIKit

class EphemerisViewController: UIViewController {

    @IBOutlet weak var ageInfo: UILabel!
    @IBOutlet weak var phaseInfo: UILabel!
    @IBOutlet weak var illuminationInfo: UILabel!
    @IBOutlet weak var colongitudeInfo: UILabel!
    @IBOutlet weak var localDateLabel: UILabel!
    @IBOutlet weak var localDateInfo: UILabel!
    @IBOutlet weak var utcDateInfo: UILabel!
    @IBOutlet weak var latitudeInfo: UILabel!
    @IBOutlet weak var longitudeInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
