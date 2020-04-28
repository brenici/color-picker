//
//  UIColor+Extensions.swift
//  ColorPicker
//
//  Created by Emilian Brenici on 26/04/2020.
//  Copyright © 2020 Emilian Brenici. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hex: String) {
        let hexString: String = (hex as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString as String)
        if hexString.hasPrefix("#") {
            if #available(iOS 13.0, *) {
                scanner.currentIndex = scanner.string.index(after: scanner.currentIndex)
            } else {
                scanner.scanLocation = 1
            }
        }
        let mask = 0x00000000FF
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        let red   = CGFloat(Int(color >> 24) & mask) / 255.0
        let green = CGFloat(Int(color >> 16) & mask) / 255.0
        let blue  = CGFloat(Int(color >> 8)  & mask) / 255.0
        let alpha = CGFloat(Int(color)       & mask) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(hue: Int, saturation: Int, brightness: Int, alpha: Int) {
        assert(hue        >= 0 && hue        <= 360, "Invalid hue component")
        assert(saturation >= 0 && saturation <= 100, "Invalid saturation component")
        assert(brightness >= 0 && brightness <= 100, "Invalid brightness component")
        assert(alpha      >= 0 && alpha      <= 256, "Invalid alpha component")
        self.init(hue: CGFloat(hue) / 359.0,
                  saturation: CGFloat(saturation) / 100.0,
                  brightness: CGFloat(brightness) / 100.0,
                  alpha: CGFloat(alpha) / 255.0)
    }
    
    func hexRGBA() -> String {
        guard let colorComponents = self.cgColor.components else { return "#FFFFFFFF" }
        return String(format: "#%02x%02x%02x%02x",
                      Int(colorComponents[0]*255.0),
                      Int(colorComponents[1]*255.0),
                      Int(colorComponents[2]*255.0),
                      Int(colorComponents[3]*255.0)).uppercased()
    }
    
    func hexRGB() -> String {
        guard let colorComponents = self.cgColor.components else { return "#FFFFFF" }
        return String(format: "#%02x%02x%02x",
                      Int(colorComponents[0]*255.0),
                      Int(colorComponents[1]*255.0),
                      Int(colorComponents[2]*255.0)).uppercased()
    }
    
    func setHueValue(to newHueValue: CGFloat) -> UIColor {
        var H: CGFloat = 0, S: CGFloat = 0, B: CGFloat = 0, A: CGFloat = 0
        guard self.getHue(&H, saturation: &S, brightness: &B, alpha: &A) else { return self }
        H = max(min(newHueValue, 1.0), 0.0)
        S = max(min(S, 1.0), 0.0)
        B = max(min(B, 1.0), 0.0)
        A = max(min(A, 1.0), 0.0)
        return UIColor(hue: H, saturation: S, brightness: B, alpha: A)
    }
    
    func setBrightnessValue(to newBrightness: CGFloat) -> UIColor {
        var H: CGFloat = 0, S: CGFloat = 0, B: CGFloat = 0, A: CGFloat = 0
        guard self.getHue(&H, saturation: &S, brightness: &B, alpha: &A) else { return self }
        H = max(min(H, 1.0), 0.0)
        S = max(min(S, 1.0), 0.0)
        B = max(min(newBrightness, 1.0), 0.0)
        A = max(min(A, 1.0), 0.0)
        return UIColor(hue: H, saturation: S, brightness: B, alpha: A)
    }
    
    func setSaturationValue(to newSaturation: CGFloat) -> UIColor {
        var H: CGFloat = 0, S: CGFloat = 0, B: CGFloat = 0, A: CGFloat = 0
        guard self.getHue(&H, saturation: &S, brightness: &B, alpha: &A) else { return self }
        H = max(min(H, 1.0), 0.0)
        S = max(min(newSaturation, 1.0), 0.0)
        B = max(min(B, 1.0), 0.0)
        A = max(min(A, 1.0), 0.0)
        return UIColor(hue: H, saturation: S, brightness: B, alpha: A)
    }
    
    func getHueValue() -> CGFloat {
        var H: CGFloat = 0, S: CGFloat = 0, B: CGFloat = 0, A: CGFloat = 0
        guard self.getHue(&H, saturation: &S, brightness: &B, alpha: &A) else { return 1 }
        return H
    }
    
    func getBrightnessValue() -> CGFloat {
        var H: CGFloat = 0, S: CGFloat = 0, B: CGFloat = 0, A: CGFloat = 0
        guard self.getHue(&H, saturation: &S, brightness: &B, alpha: &A) else { return 1 }
        return B
    }
    
    func getSaturationValue() -> CGFloat {
        var H: CGFloat = 0, S: CGFloat = 0, B: CGFloat = 0, A: CGFloat = 0
        guard self.getHue(&H, saturation: &S, brightness: &B, alpha: &A) else { return 1 }
        return S
    }
    
    func maxContrast() -> UIColor {
        var R: CGFloat = 0, G: CGFloat = 0, B: CGFloat = 0, A: CGFloat = 0
        guard self.getRed(&R, green: &G, blue: &B, alpha: &A) else { return .white }
        let luminance = ((R * 0.299) + (G * 0.587) + (B * 0.114))
        return luminance >= 0.5 ? .black : .white
    }
    
}
