//
//  LunarFeatureViewController.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 5/18/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import UIKit

class LunarFeatureViewController: UIViewController
{
    private var formatter = NumberFormatter()
    var lunarFeature: LunarFeature? { didSet { updateUI() } }
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var diameter: UILabel!
    @IBOutlet weak var quadName: UILabel!
    @IBOutlet weak var quadCode: UILabel!
    
    private func setupFormatter() {
        formatter.minimumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
    }

    private func formatDecimalCoordinateLabel(from coordinate: Double, direction labels: String) -> String {
        var directionString = ""
        let cardinalDirs = labels.components(separatedBy: " ")
        if coordinate < 0 {
            directionString = " \(cardinalDirs.last!)"
        } else {
            directionString = " \(cardinalDirs.first!)"
        }
        return formatter.string(from: coordinate as NSNumber)! + " " + directionString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFormatter()
        updateUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        preferredContentSize = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
    }
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    func updateUI() {
        name?.text = "Name: \(lunarFeature?.name ?? "")"
        type?.text = "Type: \(lunarFeature?.type ?? "")"
        latitude?.text = "Latitude: " + formatDecimalCoordinateLabel(from: lunarFeature?.latitude ?? 0.0, direction: "N S")
        longitude?.text = "Longitude: " + formatDecimalCoordinateLabel(from: lunarFeature?.longitude ?? 0.0, direction: "E W")
        diameter?.text = "Diameter: " + formatter.string(from: lunarFeature?.diameter as NSNumber? ?? 0.0)! + " km"
        quadName?.text = "Quad Name: \(lunarFeature?.quadName ?? "")"
        quadCode?.text = "Quad Code: \(lunarFeature?.quadCode ?? "")"
    }
}
