//
//  TelescopeFeaturesTableViewController.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 5/17/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import UIKit

class TelescopeFeaturesTableViewController: UITableViewController, UIUpdatable, UIPopoverPresentationControllerDelegate
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
        return lunarClubInfo?.telescopeFeatures.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LunarFeature", for: indexPath)
        cell.textLabel?.text = lunarClubInfo?.telescopeFeatures[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let destination = storyboard?.instantiateViewController(withIdentifier: LunarClubConstants.lunarFeatureSegue) as? UINavigationController
        destination?.modalPresentationStyle = .popover
        present(destination!, animated: true)
        if let seguedToMvc = destination?.contents as? LunarFeatureViewController,
            let popoverPc = destination?.popoverPresentationController {
            popoverPc.delegate = self
            popoverPc.sourceRect = tableView.rectForRow(at: indexPath)
            popoverPc.permittedArrowDirections = .any
            seguedToMvc.lunarFeature = lunarClubInfo?.telescopeFeatures[indexPath.row]
        }
    }
    
    func adaptivePresentationStyle(
        for controller: UIPresentationController,
        traitCollection: UITraitCollection
        ) -> UIModalPresentationStyle
    {
        if traitCollection.verticalSizeClass == .compact {
            return .none
        } else if traitCollection.horizontalSizeClass == .compact {
            return .overFullScreen
        } else {
            return .none
        }
    }
}
