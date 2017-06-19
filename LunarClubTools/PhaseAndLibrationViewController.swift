//
//  PhaseAndLibrationViewController.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 6/12/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import UIKit
import SceneKit

class PhaseAndLibrationViewController: UIViewController, UIUpdatable
{
    private var delegate: UIUpdatable?
    private var formatter = NumberFormatter()
    private var moonViewHelper = MoonViewHelper()
    
    @IBOutlet weak var moonView: SCNView! {
        didSet {
            let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(changeScale(byReactingTo:))
            )
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moveCamera(byReactingTo:))
            )
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(reset(byReactingTo:))
            )
            tapGestureRecognizer.numberOfTapsRequired = 2
            moonView.addGestureRecognizer(pinchGestureRecognizer)
            moonView.addGestureRecognizer(panGestureRecognizer)
            moonView.addGestureRecognizer(tapGestureRecognizer)
        }
    }
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateUI()
    }
    
    func changeScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer) {
        switch pinchRecognizer.state {
        case .changed, .ended:
            var scale = moonViewHelper.scale
            scale *= Double(pinchRecognizer.scale)
            moonViewHelper.setScale(scale)
            pinchRecognizer.scale = 1
        default:
            break
        }
    }
    
    func moveCamera(byReactingTo panRecognizer: UIPanGestureRecognizer) {
        switch panRecognizer.state {
        case .changed, .ended:
            let translation = panRecognizer.translation(in: moonView)
            let scale = CGFloat(moonViewHelper.scale)
            let viewScale = min(moonView.bounds.width, moonView.bounds.height)
            let scaleFactor = viewScale / scale
            moonViewHelper.moveCamera(Float(translation.x / scaleFactor),
                                      Float(translation.y / scaleFactor))
            panRecognizer.setTranslation(CGPoint.zero, in: moonView)
        default:
            break
        }
    }
    
    func reset(byReactingTo tapRecognizer: UITapGestureRecognizer) {
        switch tapRecognizer.state {
        case .ended:
            moonViewHelper.resetCamera()
        default:
            break
        }
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
                    self.librationLatitude?.text = "Libration Latitude: \(libLat)"
                    self.librationLongitude?.text = "Libration Longitude: \(libLon)"
                    self.subSolarLatitude?.text = "SubSolar Latitude: \(subSolLat)"
                    
                    self.moonViewHelper.resetCamera()
                    self.moonViewHelper.setAngles(moonInfo.elongation, moonInfo.librationLatitude,
                                                  moonInfo.librationLongitude, moonInfo.subSolarLatitude)
                    self.moonViewHelper.render(self.moonView)
                }
            }
        }
    }
}
