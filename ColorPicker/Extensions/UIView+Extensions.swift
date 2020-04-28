//
//  UIView+Extensions.swift
//  ColorPicker
//
//  Created by Emilian Brenici on 28/04/2020.
//  Copyright © 2020 Emilian Brenici. All rights reserved.
//

import UIKit

extension UIView {
    
    func fadeView(_ delay: CFTimeInterval, _ duration: CFTimeInterval, hidden: Bool) {
        if self.isHidden != hidden {
            self.isHidden = !hidden
            self.alpha = hidden ? 1.0 : 0.0
            UIView.animate(withDuration: duration,
                           delay: delay,
                           options: [.showHideTransitionViews, .curveEaseInOut],
                           animations: {
                            self.isHidden = hidden
                            self.alpha = hidden ? 0.0 : 1.0
            }, completion: nil )
        }
    }
    
    func addShadow(color: UIColor, opacity: Float, offset: CGSize, radius: CGFloat) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
    }
    
}
