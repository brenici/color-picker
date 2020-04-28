//
//  HueControl.swift
//  ColorPicker
//
//  Created by Emilian Brenici on 27/04/2020.
//  Copyright © 2020 Emilian Brenici. All rights reserved.
//

import UIKit

protocol HueControlDelegate {
    func hueChanged(_ huevalue: CGFloat)
    func hueApplied(_ huevalue: CGFloat)
}

class HueControl: UIView {
    
    var delegate: HueControlDelegate?
    var controlThumb: ControlThumb!
    var hueValue = CGFloat()
    var controlWidth = CGFloat()
    var margin: CGFloat { get { return controlWidth * 0.1 } }
    var thumbSize: CGSize { get { return CGSize(width: controlWidth / 8, height: controlWidth / 8) } }
    var trackWidth: CGFloat { get { return controlWidth / 28 } }
    var radius: CGFloat { get { return controlWidth / 2 - thumbSize.width / 2 } }
    var hueAngle: Float = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, color: UIColor) {
        self.init(frame: frame)
        controlWidth = self.frame.width
        commonInit()
    }
    
    private func commonInit() {
        addColorWheelView()
        addControlThumb()
        layoutControlThumb()
        addGestureRecognizers()
    }
    
    private func addGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.thumbControlPanned(_:)))
        controlThumb.addGestureRecognizer(panGesture)
    }
        
    private func addColorWheelView() {
        let colorWheelView = ColorWheel(frame: CGRect(x: margin, y: margin, width: controlWidth - (margin * 2), height: controlWidth - (margin * 2)))
        colorWheelView.backgroundColor = .clear
        self.addSubview(colorWheelView)
    }
    
    private func addControlThumb() {
        let frame = CGRect(x: 0, y: 0, width: thumbSize.width, height: thumbSize.height)
        controlThumb = ControlThumb(frame: frame)
        controlThumb.typeLabel.text = "H"
        self.addSubview(controlThumb)
    }
    
    func updateControlThumb(with huevalue: CGFloat) {
        getHueAngle(from: huevalue)
        layoutControlThumb()
    }
    
    func layoutControlThumb() {
        let newPosition = getThumbPosition(from: hueAngle)
        controlThumb.center = newPosition
        getHueValue(from: hueAngle)
    }
    
    private func getHueValue(from angle: Float) {
        hueValue = 1.0 - CGFloat(Double(angle) / (2 * Double.pi))
    }
    
    func getHueAngle(from value: CGFloat) {
        hueAngle = 2 * Float.pi * (1 - Float(value))
    }
    
    private func getHueAngle(from point: CGPoint) -> Float {
        let deltaX = Float(self.bounds.midX - point.x)
        let deltaY = Float(self.bounds.midY - point.y)
        let angle = atan2f(deltaX, deltaY)
        var adjustedAngle = angle + Float.pi / 2
        if (adjustedAngle < 0) { adjustedAngle += Float.pi * 2 }
        return adjustedAngle
    }
    
    private func getThumbPosition(from angle: Float) -> CGPoint {
        let buffer = (margin - (thumbSize.width / 2)) + (trackWidth / 2)
        let positionX = controlWidth / 2 + ((radius - buffer) * CGFloat(cos(-angle)))
        let positionY = controlWidth / 2 + ((radius - buffer) * CGFloat(sin(-angle)))
        return CGPoint(x: positionX, y: positionY)
    }
    
    @objc private func thumbControlPanned(_ recognizer: UIPanGestureRecognizer) {
        switch(recognizer.state) {
        case UIGestureRecognizer.State.changed:
            moveControlThumb(toward: recognizer.location(in: self))
            break
        case UIGestureRecognizer.State.ended:
            applyHue()
            break
        default:
            break
        }
    }
    
    private func moveControlThumb(toward point: CGPoint) {
        hueAngle = getHueAngle(from: point)
        layoutControlThumb()
        delegate?.hueChanged(hueValue)
    }
    
    func showThumbValue(_ value: String, _ color: UIColor) {
        controlThumb.valueLabel.text = value
        controlThumb.valueLabel.textColor = color
        controlThumb.typeLabel.textColor = color
    }
        
    private func applyHue() {
       delegate?.hueApplied(hueValue)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
