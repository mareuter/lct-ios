//
//  PhaseAndLibrationViewController.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 4/21/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import UIKit

class PhaseAndLibrationViewController: UIViewController, UIUpdatable {

    private var delegate: UIUpdatable?
    
    override func viewDidLoad() {
        delegate = self
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func updateUI() {
        
    }
}
