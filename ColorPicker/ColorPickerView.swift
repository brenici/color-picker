//
//  ColorPickerView.swift
//  ColorPicker
//
//  Created by Emilian Brenici on 26/04/2020.
//  Copyright © 2020 Emilian Brenici. All rights reserved.
//

import UIKit

protocol ColorPickerViewDelegate {
    func changeColor(_ color: UIColor)
    func applyColor(_ color: UIColor)
    func undoColor(_ color: UIColor)
    func hideColorPickerView()
}

class ColorPickerView: UIView {
    
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
    var currentColor: UIColor = .green
    var hueValue: CGFloat = 0.01
    var saturationValue: CGFloat = 1.0
    var brightnessValue: CGFloat = 1.0
    var screenWidth: CGFloat = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func commonInit() {
        getColorComponents()
        addControls()
        hueControl.delegate = self
        brightnessControl.delegate = self
        saturationControl.delegate = self
    }
    
    func getColorComponents() {
        hueValue = currentColor.getHueValue()
        brightnessValue = currentColor.getBrightnessValue()
        saturationValue = currentColor.getSaturationValue()
    }
    
    func setColorComponents() {
        hueControl.hueValue = hueValue
        hueControl.getHueAngle(from: hueValue)
        brightnessControl.brightnessValue = brightnessValue
        saturationControl.saturationValue = saturationValue
        undoButton.color = currentColor
    }
    
    private func addControls() {
        addHueControl()
        addBrightnessControl()
        addSaturationControl()
        addHexLabel()
        addApplyButton()
        addUndoButton()
    }
    
    private func addHueControl() {
        let frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: screenWidth)
        hueControl = HueControl(frame: frame, color: currentColor)
        self.addSubview(hueControl)
    }
    
    private func addBrightnessControl() {
        let frame = CGRect(x: (screenWidth - controlSize.width)/2,
                           y: (screenWidth * 0.35) - (controlSize.height / 2) + 4,
                           width: controlSize.width,
                           height: controlSize.height)
        brightnessControl = BrightnessControl(frame: frame, color: currentColor)
        self.addSubview(brightnessControl)    }
    
    private func addSaturationControl() {
        let frame = CGRect(x: (screenWidth - controlSize.width)/2,
                           y: (screenWidth * 0.51) - (controlSize.height / 2) + 4,
                           width: controlSize.width,
                           height: controlSize.height)
        saturationControl = SaturationControl(frame: frame, color: currentColor)
        self.addSubview(saturationControl)
    }
    
    private func addHexLabel() {
        hexValueLabel = UILabel()
        hexValueLabel.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.8, height: screenWidth * 0.1)
        hexValueLabel.layer.cornerRadius = 2
        hexValueLabel.adjustsFontSizeToFitWidth = true
        hexValueLabel.textAlignment = .center
        hexValueLabel.backgroundColor = UIColor.clear
        hexValueLabel.center = CGPoint(x: screenWidth/2, y: screenWidth*0.25)
        hexValueLabel.font = UIFont(name: "Menlo-Regular", size: hexValueLabel.bounds.height/2)
        hexValueLabel.textColor = currentColor.maxContrast()
        hexValueLabel.addShadow(color: .black, opacity: 0.4, offset: CGSize(width: 1, height: 2), radius: 3)
        hexValueLabel.text = currentColor.hexRGB()
        self.addSubview(hexValueLabel)
    }
    
    private func addApplyButton() {
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
        let image = UIImage(named: name)
        let imageView = UIImageView(image: image!)
        imageView.tintColor = .white
        imageView.frame = CGRect(x: size / 5, y: size / 6, width: size / 2, height: size / 2)
        imageView.center = CGPoint(x: size / 2, y: size / 2)
        imageView.addShadow(color: .black, opacity: 0.7, offset: .zero, radius: 3)
        imageView.clipsToBounds = false
        return imageView
    }
    
    func updateControls() {
        getColorFromComponents()
        updateControlThumbs()
        updateTrackGradients()
    }
    
    func getColorFromComponents() {
        currentColor = UIColor(hue: hueValue, saturation: saturationValue, brightness: brightnessValue, alpha: 1.0)
    }
    
    func updateControlThumbs() {
        let textColor = currentColor.maxContrast()
        hueControl.updateControlThumb(with: hueValue)
        hueControl.controlThumb.color = currentColor
        brightnessControl.updateControlThumb(with: brightnessValue)
        brightnessControl.controlThumb.color = currentColor
        saturationControl.updateControlThumb(with: saturationValue)
        saturationControl.controlThumb.color = currentColor
        applyButton.color = currentColor
        hexValueLabel.text = currentColor.hexRGB()
        hexValueLabel.textColor = textColor
        hueControl.showThumbValue("\(Int(hueValue*360))", textColor)
        brightnessControl.showThumbValue("\(Int(brightnessValue*100))", textColor)
        saturationControl.showThumbValue("\(Int(saturationValue*100))", textColor)
        applyImageView.tintColor = textColor
        undoImageView.tintColor = undoButton.color.maxContrast()
    }
    
    func updateTrackGradients() {
        brightnessControl.updateGradientTrack(colors: [currentColor.setBrightnessValue(to: 0.1), currentColor.setBrightnessValue(to: 1.0).setHueValue(to: hueValue)])
        saturationControl.updateGradientTrack(colors: [currentColor.setSaturationValue(to: 0.1), currentColor.setSaturationValue(to: 1.0).setHueValue(to: hueValue)])
    }
    
    @objc private func applyButtonTapped(_ recognizer: UITapGestureRecognizer) {
        undoButton.color = currentColor
        delegate?.hideColorPickerView()
    }
    
    @objc private func undoButtonTapped(_ recognizer: UITapGestureRecognizer) {
        delegate?.undoColor(undoButton.color)
        currentColor = undoButton.color
        getColorComponents()
        updateControls()
        delegate?.hideColorPickerView()
    }
    
    func updateColors(with color: UIColor) {
        currentColor = color
        undoButton.color = color
        applyButton.color = color
        updateControls()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
}

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
