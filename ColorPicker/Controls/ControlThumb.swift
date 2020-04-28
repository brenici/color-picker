//
//  ControlThumb.swift
//  ColorPicker
//
//  Created by Emilian Brenici on 27/04/2020.
//  Copyright © 2020 Emilian Brenici. All rights reserved.
//

import UIKit

class ControlThumb: UIView {
    
    var thumbLayer = CAShapeLayer()
    
    var typeLabel = UILabel()
    var valueLabel = UILabel()
    var color = UIColor.clear {
        didSet { thumbLayer.fillColor = color.cgColor }
    }

    override var frame: CGRect {
        didSet { self.layoutThumbLayer() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        addThumbLayer()
        self.addShadow(color: .black, opacity: 0.4, offset: CGSize(width: 1, height: 2), radius: 3)
        addTypeLabel()
        addValueLabel()
    }
    
    private func addThumbLayer() {
        thumbLayer.shouldRasterize = true
        layoutThumbLayer()
        thumbLayer.fillColor = color.cgColor
        self.layer.addSublayer(thumbLayer)
    }
    
    private func layoutThumbLayer() {
        thumbLayer.path = UIBezierPath(ovalIn: self.bounds).cgPath
        thumbLayer.strokeColor = UIColor.white.withAlphaComponent(0.9).cgColor
        thumbLayer.lineWidth = self.bounds.width / 15
    }
    
    private func addTypeLabel() {
        typeLabel = addLabel(fontSize: self.bounds.height * 0.25, yPosition: self.bounds.height * 0.28)
        self.addSubview(typeLabel)
    }
    
    private func addValueLabel() {
        valueLabel = addLabel(fontSize: self.bounds.height * 0.34, yPosition: self.bounds.height * 0.6)
        self.addSubview(valueLabel)
    }
    
    private func addLabel(fontSize: CGFloat, yPosition: CGFloat) -> UILabel {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.center = CGPoint(x: self.bounds.width / 2, y: yPosition)
        label.font = UIFont(name: "Avenir Next Demi Bold", size: fontSize)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowOpacity = 0.7
        label.layer.shadowRadius = 3
        return label
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
