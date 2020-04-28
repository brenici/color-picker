//
//  GradientTrack.swift
//  ColorPicker
//
//  Created by Emilian Brenicion 27/04/2020.
//  Copyright © 2020 Emilian Brenici. All rights reserved.
//

import UIKit

class GradientTrack: UIView {
    
    let gradient = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.addSublayer(gradient)
        self.layer.backgroundColor = UIColor.white.withAlphaComponent(0.8).cgColor
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
}

