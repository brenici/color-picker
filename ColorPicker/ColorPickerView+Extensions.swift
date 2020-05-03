//
//  ColorPickerView+Extensions.swift
//  ColorPicker
//
//  Created by Emilian Brenici on 03/05/2020.
//  Copyright © 2020 Emilian Brenici. All rights reserved.
//

import UIKit

extension ColorPickerView: HueControlDelegate {
    
    func hueChanged(_ huevalue: CGFloat) {
        hueValue = huevalue
        currentColor = currentColor.setHueValue(to: huevalue)
        delegate?.changeColor(currentColor)
        updateControls()
    }
    
    func hueApplied(_ huevalue: CGFloat) {
        delegate?.applyColor(currentColor)
    }
    
}

extension ColorPickerView: BrightnessControlDelegate {
    
    func brightnessChanged(_ brightness: CGFloat) {
        brightnessValue = brightness
        currentColor = currentColor.setBrightnessValue(to: brightness)
        delegate?.changeColor(currentColor)
        updateControls()
    }
    
    func brightnessApplied(_ brightness: CGFloat) {
        currentColor = currentColor.setBrightnessValue(to: brightness)
        delegate?.applyColor(currentColor)
    }
    
}

extension ColorPickerView: SaturationControlDelegate {
    
    func saturationChanged(_ saturation: CGFloat) {
        saturationValue = saturation
        currentColor = currentColor.setSaturationValue(to: saturation)
        delegate?.changeColor(currentColor)
        updateControls()
    }
    
    func saturationApplied(_ saturation: CGFloat) {
        currentColor = currentColor.setSaturationValue(to: saturation)
        delegate?.applyColor(currentColor)
    }
    
}
