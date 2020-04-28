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
        addGradientTrack()
        addControlThumb()
        addGestureRecognizers()
    }
    
    private func addGradientTrack() {
        let trackBezel = GradientTrack()
        let bezelWidth = self.bounds.height / 20
        trackBezel.frame = self.bounds.insetBy(dx: (thumbSize.width / 4) - bezelWidth, dy: (self.bounds.height / 2.56) - bezelWidth)
        trackBezel.layer.cornerRadius = trackBezel.bounds.height / 2
        // MARK: TO DO: add shadow
        self.addSubview(trackBezel)
        gradientTrack.frame = self.bounds.insetBy(dx: thumbSize.width / 4, dy: self.bounds.height / 2.56)
        gradientTrack.layer.cornerRadius = gradientTrack.bounds.height / 2
        gradientTrack.layer.masksToBounds = true
        self.addSubview(gradientTrack)
    }
    
    private func addControlThumb() {
        let frame = CGRect(x: 0, y: 0, width: thumbSize.width, height: thumbSize.height)
        controlThumb = ControlThumb(frame: frame)
        self.addSubview(controlThumb)
        controlThumb.typeLabel.text = "B"
    }
    
    private func addGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.thumbControlPanned(_:)))
        controlThumb.addGestureRecognizer(panGesture)
    }
    
    @objc private func thumbControlPanned(_ recognizer: UIPanGestureRecognizer) {
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
        let thumbPosition = delta/(self.bounds.width-thumbSize.width)
        brightnessValue = max(min(thumbPosition, 1.0), 0.0)
        layoutControlThumb(animated: true)
        //        delegate?.saturationChanged(saturationValue)
    }
    
    func layoutControlThumb(animated: Bool) {
        let newPosition = (brightnessValue * (bounds.width - controlThumb.bounds.width)) + controlThumb.bounds.width/2
        if animated {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: { () -> Void in
                self.controlThumb.center.x = newPosition
            })
        } else {
            controlThumb.center.x = newPosition
        }
        // set controlThumb Color
    }
    
    private func applyBrightness() {
        delegate?.brightnessApplied(brightnessValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
