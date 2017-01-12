//
//  MoonInfoViewController.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 1/8/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import UIKit

class MoonInfoViewController: UIViewController {

    @IBOutlet private weak var localDateLabel: UILabel!
    @IBOutlet private weak var utcDateLabel: UILabel!
    @IBOutlet private weak var moonAgeLabel: UILabel!
    @IBOutlet private weak var illuminationLabel: UILabel!
    @IBOutlet private weak var colongitudeLabel: UILabel!
    @IBOutlet private weak var librationLatitudeLabel: UILabel!
    @IBOutlet private weak var librationLongitudeLabel: UILabel!
    @IBOutlet private weak var altitudeLabel: UILabel!
    @IBOutlet private weak var azimuthLabel: UILabel!
    
    @IBOutlet private weak var firstPhaseLabel: UILabel!
    @IBOutlet private weak var secondPhaseLabel: UILabel!
    @IBOutlet private weak var thirdPhaseLabel: UILabel!
    @IBOutlet private weak var fourthPhaseLabel: UILabel!

    @IBOutlet private weak var firstPhaseIcon: UIImageView!
    @IBOutlet private weak var secondPhaseIcon: UIImageView!
    @IBOutlet private weak var thirdPhaseIcon: UIImageView!
    @IBOutlet private weak var fourthPhaseIcon: UIImageView!
}

