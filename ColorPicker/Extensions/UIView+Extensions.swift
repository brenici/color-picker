//
//  UIView+Extensions.swift
//  ColorPicker
//
//  Created by Emilian Brenici on 28/04/2020.
//  Copyright © 2020 Emilian Brenici. All rights reserved.
//

import UIKit

extension UIView {
    
    func addShadow(color: UIColor, opacity: Float, offset: CGSize, radius: CGFloat) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
    }
    
}
