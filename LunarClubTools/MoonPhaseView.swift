//
//  MoonPhaseView.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 4/21/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import UIKit

@IBDesignable
class MoonPhaseView: UIView {

    @IBInspectable
    var illumnationFraction: CGFloat = 0.3 { didSet { setNeedsDisplay() } }

    @IBInspectable
    var isWaxing: Bool = true { didSet { setNeedsDisplay() } }

    @IBInspectable
    var scale: CGFloat = 0.9 { didSet { setNeedsDisplay() } }

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

    private func drawQuarterMoon() -> UIBezierPath {
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

    override func draw(_ rect: CGRect) {
        UIColor.clear.setStroke()
        earthShineColor.setFill()
        drawBackground().fill()
        drawBackground().stroke()
        UIColor.white.set()
        drawQuarterMoon().fill()
        drawQuarterMoon().stroke()
        overlapColor.set()
        UIColor.clear.setStroke()
        drawOverlap().fill()
        drawOverlap().stroke()
    }
}
