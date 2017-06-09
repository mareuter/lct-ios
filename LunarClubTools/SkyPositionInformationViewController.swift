//
//  SkyPositionInformationViewController.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 6/8/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import UIKit

class SkyPositionInformationViewController: UITableViewController, UIUpdatable
{
    private var delegate: UIUpdatable?
    
    override func viewDidLoad() {
        delegate = self
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func updateUI() {
        if view != nil {
            if let lcpvc = parent as? LunarClubPageViewController {
                if let lunarClubInfo = lcpvc.lunarClubInfo {
                    
                }
            }
        }
    }
}
