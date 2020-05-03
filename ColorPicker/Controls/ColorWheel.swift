//
//  ColorWheel.swift
//  ColorPicker
//
//  Created by Emilian Brenici on 27/04/2020.
//  Copyright © 2020 Emilian Brenici. All rights reserved.
//

import UIKit

class ColorWheel: UIView {
     
    var wheelLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        addWheelLayer()
        self.addShadow(color: .black, opacity: 0.4, offset: CGSize(width: 1, height: 2), radius: 3)
    }
    
    private func addWheelLayer() {
        wheelLayer.shouldRasterize = true
        layoutWheelLayer()
        wheelLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(wheelLayer)
    }
    
    private func layoutWheelLayer() {
        let strokeWidth: CGFloat = self.bounds.width / 32
        let bezelWidth: CGFloat = self.bounds.width / 240
        let point: CGFloat = (strokeWidth / 2) + (bezelWidth * 2)
        let wheelDiameter: CGFloat = self.bounds.width - (strokeWidth) - (bezelWidth * 4)
        let wheelPath = UIBezierPath(ovalIn: CGRect(x: point, y: point, width: wheelDiameter, height: wheelDiameter))
        wheelLayer.path = wheelPath.cgPath
        wheelLayer.strokeColor = UIColor.white.withAlphaComponent(0.9).cgColor
        wheelLayer.lineWidth = strokeWidth + (bezelWidth * 4)
        let wheelCenter = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let wheelRadius = (min(self.bounds.width, self.bounds.height) / 2 - (strokeWidth / 2)) - (bezelWidth * 2)
        var lastAngle: CGFloat = 0
        for angle in 1...360 {
            let currentAngle = CGFloat(angle) / 180 * CGFloat.pi
            let wheelRay = CAShapeLayer()
            let wheelRayPath = UIBezierPath(arcCenter: wheelCenter, radius: wheelRadius, startAngle: lastAngle, endAngle: currentAngle + 0.01, clockwise: true)
            wheelRay.path = wheelRayPath.cgPath
            wheelRay.strokeColor = UIColor(hue: CGFloat(angle) / 360, saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor
            wheelRay.lineWidth = strokeWidth
            wheelLayer.addSublayer(wheelRay)
            lastAngle = currentAngle
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
