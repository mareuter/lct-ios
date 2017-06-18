//
//  MoonViewHelper.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 6/12/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import Foundation
import SceneKit

class MoonViewHelper
{
    var scale: Double = MoonInfoConstants.maxCameraZoomOut
    var color = UIColor.cyan
 
    private var sunXPosition: Float = 0.0
    private var sunZPosition: Float = MoonInfoConstants.sunRadius
    private var libLatAngleRad: Float = 0.0
    private var libLonAngleRad: Float = 0.0
    private var librationAngleRad: Float = 0.0
    private var cylinderXPosition: Float = MoonInfoConstants.arrowRadius
    private var cylinderYPosition: Float = 0.0
    private var coneXPosition: Float = MoonInfoConstants.arrowRadius - MoonInfoConstants.coneOffset
    private var coneYPosition: Float = 0.0
    
    private var scene = SCNScene()
    private var camera = SCNCamera()
    private var cameraNode = SCNNode()
    private var sunShine = SCNLight()
    private var sunShineNode = SCNNode()
    private var earthShine = SCNLight()
    private var earthShineNode = SCNNode()
    private var moon = SCNSphere(radius: 1.0)
    private var moonMap = SCNMaterial()
    private var moonNode = SCNNode()
    private var cylinder = SCNCylinder(radius: 0.01, height: 0.07)
    private var cylinderNode = SCNNode()
    private var cone = SCNCone(topRadius: 0.0, bottomRadius: 0.02, height: 0.03)
    private var coneNode = SCNNode()
    private var arrowMaterial = SCNMaterial()
    private var arrowNode = SCNNode()
    private var arrowLight = SCNLight()
    private var arrowLightNode = SCNNode()
    
    func render(_ moonView: SCNView) {
        moonView.scene = scene
        
        setupCamera()
        setupSun()
        setupEarthShine()
        setupMoon()
        setupArrowLight()
        setupLibrationArrow()
        setupConstraints()
        
        self.scene.rootNode.addChildNode(cameraNode)
        self.scene.rootNode.addChildNode(sunShineNode)
        self.scene.rootNode.addChildNode(earthShineNode)
        self.scene.rootNode.addChildNode(moonNode)
        self.scene.rootNode.addChildNode(arrowNode)
        self.scene.rootNode.addChildNode(arrowLightNode)
    }
    
    func setColor(_ color: UIColor) {
        self.color = color
        self.arrowMaterial.diffuse.contents = self.color
    }
    
    func setAngles(_ elongation: Double, _ librationLatitude: Double,
                   _ librationLongitude: Double, _ subSolarLatitude: Double) {
        
        var phaseAngle = elongation + 180.0
        if phaseAngle > 360.0 {
            phaseAngle -= 360.0
        }
        let phaseAngleRad = GLKMathDegreesToRadians(Float(-phaseAngle))
        self.sunXPosition = MoonInfoConstants.sunRadius * sinf(phaseAngleRad)
        self.sunZPosition = MoonInfoConstants.sunRadius * cosf(phaseAngleRad)
        
        self.libLatAngleRad = GLKMathDegreesToRadians(Float(librationLatitude))
        self.libLonAngleRad = GLKMathDegreesToRadians(Float(librationLongitude))
        self.librationAngleRad = atan2f(self.libLatAngleRad, self.libLonAngleRad)
        let librationCosineAngle = cosf(self.librationAngleRad)
        let librationSineAngle = sinf(self.librationAngleRad)
        self.cylinderXPosition = MoonInfoConstants.arrowRadius * librationCosineAngle
        self.cylinderYPosition = MoonInfoConstants.arrowRadius * librationSineAngle
        let difference = MoonInfoConstants.arrowRadius - MoonInfoConstants.coneOffset
        self.coneXPosition = difference * librationCosineAngle
        self.coneYPosition = difference * librationSineAngle
    }

    func moveCamera(_ x: Float, _ y: Float) {
        // Coordinate system for x is opposite to pan direction
        var newX = self.cameraNode.position.x - x
        var newY = self.cameraNode.position.y + y
        if fabsf(newX) > MoonInfoConstants.maxCameraPosition {
            newX = sign(newX) * MoonInfoConstants.maxCameraPosition
        }
        if fabsf(newY) > MoonInfoConstants.maxCameraPosition {
            newY = sign(newY) * MoonInfoConstants.maxCameraPosition
        }
        self.cameraNode.position.x = newX
        self.cameraNode.position.y = newY
    }
    
    func resetCamera() {
        self.cameraNode.position.x = 0.0
        self.cameraNode.position.y = 0.0
        self.camera.orthographicScale = MoonInfoConstants.maxCameraZoomOut
    }
    
    func setScale(_ scale: Double) {
        if scale > MoonInfoConstants.maxCameraZoomOut {
            self.scale = MoonInfoConstants.maxCameraZoomOut
        } else {
            self.scale = scale
        }
        self.camera.orthographicScale = self.scale
    }
    
    private func setupCamera() {
        self.camera.usesOrthographicProjection = true
        self.camera.orthographicScale = self.scale
        self.cameraNode.camera = self.camera
        self.cameraNode.position = SCNVector3(x: 0.0, y: 0.0, z: MoonInfoConstants.cameraRadius)
    }
    
    private func setupSun() {
        self.sunShine.type = SCNLight.LightType.omni
        self.sunShine.intensity = CGFloat(MoonInfoConstants.sunShineFlux)
        self.sunShineNode.light = self.sunShine
        self.sunShineNode.position = SCNVector3(x: self.sunXPosition, y: 0.0, z: self.sunZPosition)
    }
    
    private func setupEarthShine() {
        self.earthShine.type = SCNLight.LightType.omni
        self.earthShine.intensity = CGFloat(MoonInfoConstants.earthShineFlux)
        self.earthShineNode.light = self.earthShine
        self.earthShineNode.position = SCNVector3(x: 0.0, y: 0.0, z: MoonInfoConstants.earthShineRadius)
    }
    
    private func setupMoon() {
        self.moon.segmentCount = MoonInfoConstants.numMoonSegments
        self.moonMap.diffuse.contents = #imageLiteral(resourceName: "MoonMap")
        self.moon.materials = [self.moonMap]
        self.moonNode.geometry = self.moon
        self.moonNode.eulerAngles = SCNVector3(x: self.libLatAngleRad, y: -self.libLonAngleRad, z: 0.0)
    }
    
    private func setupArrowLight() {
        self.arrowLight.type = SCNLight.LightType.spot
        self.arrowLight.intensity = CGFloat(MoonInfoConstants.arrowLightFlux)
        self.arrowLightNode.light = self.arrowLight
        self.arrowLightNode.position = SCNVector3(x: self.cylinderXPosition, y: self.cylinderYPosition, z: MoonInfoConstants.arrowZPosition)
    }
    
    private func setupLibrationArrow() {
        self.arrowMaterial.diffuse.contents = self.color
        self.cylinder.materials = [self.arrowMaterial]
        self.cone.materials = [self.arrowMaterial]
        self.cylinderNode.geometry = self.cylinder
        self.cylinderNode.position = SCNVector3(x: self.cylinderXPosition, y: self.cylinderYPosition, z: 0.0)
        self.cylinderNode.eulerAngles = SCNVector3(x: 0.0, y: 0.0, z: .pi/2 + self.librationAngleRad)
        self.coneNode.geometry = self.cone
        self.coneNode.position = SCNVector3(x: self.coneXPosition, y: self.coneYPosition, z: 0.0)
        self.coneNode.eulerAngles = SCNVector3(x: 0.0, y: 0.0, z: .pi/2 + self.librationAngleRad)
        self.arrowNode.addChildNode(self.cylinderNode)
        self.arrowNode.addChildNode(self.coneNode)
    }
    
    private func setupConstraints() {
        let moonConstraint = SCNLookAtConstraint(target: self.moonNode)
        moonConstraint.isGimbalLockEnabled = true
        self.sunShineNode.constraints = [moonConstraint]
        self.earthShineNode.constraints = [moonConstraint]
        let arrowConstraint = SCNLookAtConstraint(target: self.cylinderNode)
        arrowConstraint.isGimbalLockEnabled = true
        self.arrowLightNode.constraints = [arrowConstraint]
    }
}
