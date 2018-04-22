//
//  MoonPhaseView.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 4/21/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class MoonPhaseView: UIView
{
    @IBInspectable
    var illumnationFraction: CGFloat = 0.3 { didSet { setNeedsDisplay() } }

    @IBInspectable
    var phaseState: Int = 2 { didSet { setNeedsDisplay() } }

    @IBInspectable
    var scale: CGFloat = 0.9 { didSet { setNeedsDisplay() } }

    @IBInspectable
    var showLibration: Bool = true { didSet { setNeedsDisplay() } }

    @IBInspectable
    var librationLatitude: Double = 0.0 { didSet { setNeedsDisplay() } }

    @IBInspectable
    var librationLongitude: Double = 0.0 { didSet { setNeedsDisplay() } }

    @IBInspectable
    var librationMarkerColor: UIColor = UIColor.cyan { didSet { setNeedsDisplay() } }

    private var lineWidth: CGFloat = 1.0

    private var bo: CGFloat {
        return 1.0 - 2.0 * max(0, min(illumnationFraction, 1))
    }
    
    private var earthShineColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)

    private var overlapColor: UIColor {
        if bo < 0 {
            return UIColor.white
        } else {
            return earthShineColor
        }
    }

    private var moonRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }

    private var moonCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }

    private func drawBackground() -> UIBezierPath {
        let path = UIBezierPath(arcCenter: moonCenter, radius: moonRadius,
                                startAngle: 0.0, endAngle: CGFloat.pi * 2.0,
                                clockwise: true)
        path.lineWidth = lineWidth
        return path
    }

    private func drawQuarterMoon(_ isWaxing: Bool) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: moonCenter, radius: moonRadius,
                                startAngle: 1.5 * CGFloat.pi, endAngle: CGFloat.pi / 2.0,
                                clockwise: isWaxing)
        path.lineWidth = lineWidth
        return path
    }

    private func drawOverlap() -> UIBezierPath {
        let illuminationCord = fabs(bo) * 2.0 * moonRadius
        let origin = CGPoint(x: moonCenter.x - 0.5 * illuminationCord,
                             y: moonCenter.y - moonRadius)
        let path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: illuminationCord,
                                                                            height: moonRadius * 2.0)))
        path.lineWidth = lineWidth
        return path
    }
    
    private func drawFractionIlluminatedMoon(_ isWaxing: Bool) {
        earthShineColor.setFill()
        drawBackground().fill()
        UIColor.white.setFill()
        drawQuarterMoon(isWaxing).fill()
        overlapColor.setFill()
        drawOverlap().fill()
    }

    private func drawLibration() -> UIBezierPath {
        let libLat = Measurement(value: librationLatitude, unit: UnitAngle.degrees)
        let libLon = Measurement(value: librationLongitude, unit: UnitAngle.degrees)
        let angle = atan2(libLat.converted(to: UnitAngle.radians).value, libLon.converted(to: UnitAngle.radians).value)
        let magnitude = max(2, sqrt(libLon.value * libLon.value + libLat.value * libLat.value))
        let xOffset = moonRadius * CGFloat(cos(angle))
        let yOffset = moonRadius * CGFloat(sin(angle))
        let librationCenter = CGPoint(x: moonCenter.x + xOffset, y: moonCenter.y - yOffset)
        let path = UIBezierPath(arcCenter: librationCenter, radius: CGFloat(magnitude),
                                startAngle: 0.0, endAngle: CGFloat.pi * 2.0, clockwise: true)
        return path
    }

    override func draw(_ rect: CGRect) {
        phaseState = max(0, min(phaseState, 3))
        switch phaseState {
        case 0:
            earthShineColor.setFill()
            drawBackground().fill()
        case 2:
            UIColor.white.setFill()
            drawBackground().fill()
        case 3:
            drawFractionIlluminatedMoon(false)
        case 1:
            drawFractionIlluminatedMoon(true)
        default:
            break
        }
        if showLibration {
            librationMarkerColor.setFill()
            drawLibration().fill()
        }
    }
}
