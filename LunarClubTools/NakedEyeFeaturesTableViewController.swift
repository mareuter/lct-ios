//
//  NakedEyeFeaturesTableViewController.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 5/16/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import UIKit

class NakedEyeFeaturesTableViewController: UITableViewController, UIUpdatable
{
    private var delegate: UIUpdatable?
    private var lunarClubInfo: LunarClubInfo?
    
    override func viewDidLoad() {
        delegate = self
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    func updateUI() {
        if view != nil {
            if let lcpvc = parent as? LunarClubPageViewController {
                if let lci = lcpvc.lunarClubInfo {
                    lunarClubInfo = lci
                    tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lunarClubInfo?.nakedEyeFeatures.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LunarFeature", for: indexPath)
        cell.textLabel?.text = lunarClubInfo?.nakedEyeFeatures[indexPath.row].name
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
