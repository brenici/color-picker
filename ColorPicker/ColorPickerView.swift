//
//  ColorPickerView.swift
//  ColorPicker
//
//  Created by Emilian Brenici on 26/04/2020.
//  Copyright © 2020 Emilian Brenici. All rights reserved.
//

import UIKit

protocol ColorPickerViewDelegate {
    func colorChanged(_ color: UIColor)
    func changeColor(_ color: UIColor)
    func applyColor(_ color: UIColor)
    func undoColor(_ color: UIColor)
}

class ColorPickerView: UIView {

    let fileName = (#file as NSString).lastPathComponent // DEBUG ONLY

    var delegate: ColorPickerViewDelegate?
    
    var hueControl: HueControl!
    var brightnessControl: BrightnessControl!
    var saturationControl: SaturationControl!
    var hexValueLabel: UILabel!
    var applyButton: ControlThumb!
    var applyImageView = UIImageView()
    var undoButton: ControlThumb!
    var undoImageView = UIImageView()

    
    var controlSize: CGSize {
        get { return CGSize(width: screenWidth / 2.4, height: screenWidth / 8) }
    }

    var currentColor = UIColor.green
    var hsbCompenents: [CGFloat] = [0.1, 1.0, 1.0]
    var hueValue: CGFloat = 0.1
    var saturationValue: CGFloat = 1.0
    var brightnessValue: CGFloat = 1.0
    
    var screenWidth: CGFloat = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)

    override init(frame: CGRect) {
        print("File: \(fileName), func: \(#function), line: \(#line)")
        super.init(frame: frame)
//        self.commonInit()
    }
    
    private func commonInit() {
        print("File: \(fileName), func: \(#function), line: \(#line)")
        getColorComponents()
        addControls()
    }
    
    func getColorComponents() {
        print("File: \(fileName), func: \(#function), line: \(#line)")
        hueValue = currentColor.getHueValue()
        brightnessValue = currentColor.getBrightnessValue()
        saturationValue = currentColor.getSaturationValue()
    }
    
    private func addControls() {
        print("File: \(fileName), func: \(#function), line: \(#line)")
        addHueControl()
        addBrightnessControl()
        addSaturationControl()
        addHexLabel()
        addApplyButton()
        addUndoButton()
    }
        
    private func addHueControl() {
        print("File: \(fileName), func: \(#function), line: \(#line)")
        let frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: screenWidth)
        hueControl = HueControl(frame: frame, color: currentColor, components: hsbCompenents)
        self.addSubview(hueControl)
    }
    
    private func addBrightnessControl() {
        print("File: \(fileName), func: \(#function), line: \(#line)")
        let frame = CGRect(x: (screenWidth - controlSize.width)/2,
                           y: (screenWidth * 0.35) - (controlSize.height / 2) + 4,
                           width: controlSize.width,
                           height: controlSize.height)
        brightnessControl = BrightnessControl(frame: frame, color: currentColor, components: hsbCompenents)
        self.addSubview(brightnessControl)    }
    
    private func addSaturationControl() {
        print("File: \(fileName), func: \(#function), line: \(#line)")
        let frame = CGRect(x: (screenWidth - controlSize.width)/2,
                           y: (screenWidth * 0.51) - (controlSize.height / 2) + 4,
                           width: controlSize.width,
                           height: controlSize.height)
        saturationControl = SaturationControl(frame: frame, color: currentColor, components: hsbCompenents)
        self.addSubview(saturationControl)
    }
    
    private func addHexLabel() {
        print("File: \(fileName), func: \(#function), line: \(#line)")
        hexValueLabel = UILabel()
        hexValueLabel.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.8, height: screenWidth * 0.1)
        hexValueLabel.layer.cornerRadius = 2
        hexValueLabel.adjustsFontSizeToFitWidth = true
        hexValueLabel.textAlignment = .center
        hexValueLabel.backgroundColor = UIColor.clear
        hexValueLabel.center = CGPoint(x: screenWidth/2, y: screenWidth*0.25)
        hexValueLabel.font = UIFont(name: "Menlo-Regular", size: hexValueLabel.bounds.height/2)
        hexValueLabel.textColor = currentColor.maxContrast()
        // MARK: TO DO: add shadow
        hexValueLabel.text = currentColor.hexRGB()
        self.addSubview(hexValueLabel)
    }
    
    private func addApplyButton() {
        print("File: \(fileName), func: \(#function), line: \(#line)")
        let frame = CGRect(x: (screenWidth / 2) + (controlSize.height * 0.22),
                           y: (screenWidth * 0.68) - (controlSize.height / 2) + 4,
                           width: controlSize.height,
                           height: controlSize.height)
        applyButton = ControlThumb(frame: frame)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.applyButtonTapped(_:)))
        applyButton.addGestureRecognizer(tapRecognizer)
        applyImageView = addButtonImage(with: applyButton.bounds.width, name: "icon_apply")
        applyButton.addSubview(applyImageView)
        self.addSubview(applyButton)
    }
    
    private func addUndoButton() {
           print("File: \(fileName), func: \(#function), line: \(#line)")
           let frame = CGRect(x: (screenWidth / 2) - (controlSize.height * 1.22),
                              y: (screenWidth * 0.68) - (controlSize.height / 2) + 4,
                              width: controlSize.height,
                              height: controlSize.height)
           undoButton = ControlThumb(frame: frame)
           let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.undoButtonTapped(_:)))
           undoButton.addGestureRecognizer(tapRecognizer)
           undoImageView = addButtonImage(with: applyButton.bounds.width, name: "icon_undo")
           undoButton.addSubview(undoImageView)
           self.addSubview(undoButton)
       }
    
    private func addButtonImage(with size: CGFloat, name: String) -> UIImageView {
        print("File: \(fileName), func: \(#function), line: \(#line)")
        let image = UIImage(named: name)
        let imageView = UIImageView(image: image!)
        imageView.tintColor = .white
        imageView.frame = CGRect(x: size / 5, y: size / 6, width: size / 2, height: size / 2)
        imageView.center = CGPoint(x: size / 2, y: size / 2)
        // MARK: TO DO: add shadow
        imageView.clipsToBounds = false
        return imageView
    }
    
    @objc private func applyButtonTapped(_ recognizer: UITapGestureRecognizer) {
        print("File: \(fileName), func: \(#function), line: \(#line)")
        // apply and save color
        // hide color picker
    }

    @objc private func undoButtonTapped(_ recognizer: UITapGestureRecognizer) {
        print("File: \(fileName), func: \(#function), line: \(#line)")
        // undo and save color
        // hide color picker
    }
    
    required init?(coder aDecoder: NSCoder) {
        print("File: \(fileName), func: \(#function), line: \(#line)")
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
}

extension ColorPickerView: HueControlDelegate {
    
    func hueChanged(_ huevalue: CGFloat) {
        // update color
    }
    
    func hueApplied(_ huevalue: CGFloat) {
        // save color
    }
    
}

extension ColorPickerView: BrightnessControlDelegate {
    
    func brightnessChanged(_ brightness: CGFloat) {
        delegate?.changeColor(UIColor(hue: hueValue, saturation: saturationValue, brightness: brightness, alpha: 1.0))
    }
    
    func brightnessApplied(_ brightness: CGFloat) {
        // save color
    }
    
}

extension ColorPickerView: SaturationControlDelegate {
    
    func saturationChanged(_ saturation: CGFloat) {
        // update color
    }
    
    func saturationApplied(_ saturation: CGFloat) {
        // save color
    }
    
}
