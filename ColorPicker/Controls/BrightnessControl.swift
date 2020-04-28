//
//  BrightnessControl.swift
//  ColorPicker
//
//  Created by Emilian Brenici on 27/04/2020.
//  Copyright © 2020 Emilian Brenici. All rights reserved.
//

import UIKit

protocol BrightnessControlDelegate {
    func brightnessChanged(_ brightness: CGFloat)
    func brightnessApplied(_ brightness: CGFloat)
}

class BrightnessControl: UIView {
    
    let fileName = (#file as NSString).lastPathComponent // DEBUG ONLY
    var delegate: BrightnessControlDelegate?
    let gradientTrack = GradientTrack()
    var controlThumb: ControlThumb!
    var brightnessValue = CGFloat()
    var thumbSize: CGSize {
        get { return CGSize(width: self.bounds.height, height: self.bounds.height) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, color: UIColor, components: [CGFloat]) {
        self.init(frame: frame)
        self.commonInit()
    }
    
    private func commonInit() {
        print("File: \(fileName), func: \(#function), line: \(#line)")
        addGradientTrack()
        addControlThumb()
        layoutControlThumb()
        addGestureRecognizers()
    }
    
    private func addGradientTrack() {
        print("File: \(fileName), func: \(#function), line: \(#line)")
        let trackBezel = GradientTrack()
        let bezelWidth = self.bounds.height / 20
        trackBezel.frame = self.bounds.insetBy(dx: (thumbSize.width / 4) - bezelWidth, dy: (self.bounds.height / 2.56) - bezelWidth)
        trackBezel.layer.cornerRadius = trackBezel.bounds.height / 2
        trackBezel.addShadow(color: .black, opacity: 0.4, offset: CGSize(width: 1, height: 2), radius: 3)
        self.addSubview(trackBezel)
        gradientTrack.frame = self.bounds.insetBy(dx: thumbSize.width / 4, dy: self.bounds.height / 2.56)
        gradientTrack.layer.cornerRadius = gradientTrack.bounds.height / 2
        gradientTrack.layer.masksToBounds = true
        self.addSubview(gradientTrack)
    }
    
    private func addControlThumb() {
        print("File: \(fileName), func: \(#function), line: \(#line)")
        let frame = CGRect(x: 0, y: 0, width: thumbSize.width, height: thumbSize.height)
        controlThumb = ControlThumb(frame: frame)
        self.addSubview(controlThumb)
        controlThumb.typeLabel.text = "B"
    }
    
    private func addGestureRecognizers() {
        print("File: \(fileName), func: \(#function), line: \(#line)")
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.thumbControlPanned(_:)))
        controlThumb.addGestureRecognizer(panGesture)
    }
    
    @objc private func thumbControlPanned(_ recognizer: UIPanGestureRecognizer) {
        print("File: \(fileName), func: \(#function), line: \(#line)")
        switch(recognizer.state) {
        case UIGestureRecognizer.State.changed:
            let point = recognizer.location(in: self).x-(thumbSize.width/2)
            moveThumbTowardPoint(point)
            break
        case UIGestureRecognizer.State.ended:
            applyBrightness()
            break
        default: break
        }
    }
    
    private func moveThumbTowardPoint(_ delta: CGFloat) {
        print("File: \(fileName), func: \(#function), line: \(#line)")
        let thumbPosition = delta/(self.bounds.width-thumbSize.width)
        brightnessValue = max(min(thumbPosition, 1.0), 0.0)
        layoutControlThumb()
        delegate?.brightnessChanged(brightnessValue)
    }
    
    func layoutControlThumb() {
        print("File: \(fileName), func: \(#function), line: \(#line)")
        let newPosition = (brightnessValue * (bounds.width - controlThumb.bounds.width)) + controlThumb.bounds.width/2
        controlThumb.center.x = newPosition
    }
    
    func updateGradientTrack(colors: [UIColor]) {
        gradientTrack.gradient.frame = gradientTrack.bounds
        gradientTrack.gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradientTrack.gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradientTrack.gradient.colors = [colors[0].cgColor,  colors[1].cgColor]
    }
    
    private func applyBrightness() {
        print("File: \(fileName), func: \(#function), line: \(#line)")
        print(brightnessValue)
        delegate?.brightnessApplied(brightnessValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}