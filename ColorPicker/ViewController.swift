//
//  ViewController.swift
//  ColorPicker
//
//  Created by Emilian Brenici on 26/04/2020.
//  Copyright © 2020 Emilian Brenici. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var colorPickerView: ColorPickerView!
    @IBOutlet weak var tapLabel: UILabel!
        
    let defaults = UserDefaults.standard
    let defaultColorKey = "defaultColor"
    var defaultColor = UIColor()
    var didUpdateLayout = false
    
    var shouldStatusBarBeDark = true { didSet { layoutStatusBar() } }
    override var preferredStatusBarStyle: UIStatusBarStyle { return checkCurrentColor() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorPickerView.delegate = self
        addGestureRecognisers()
        getDefaultColor()
        backgroundView.backgroundColor = defaultColor
        changeStatusBarStyle(for: defaultColor)
        tapLabel.textColor = defaultColor.maxContrast()
        tapLabel.addShadow(color: .black, opacity: 0.3, offset: CGSize(width: 1, height: 1), radius: 3)
        initiateColorPicker()
    }
    
    func initiateColorPicker() {
        colorPickerView.translatesAutoresizingMaskIntoConstraints = false
        colorPickerView.currentColor = defaultColor
        colorPickerView.getColorComponents()
        colorPickerView.setColorComponents()
        colorPickerView.updateControls()
    }

    override func viewWillLayoutSubviews() {
        if !didUpdateLayout {
            updateLayout()
        }
    }
    
    func layoutStatusBar() {
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    func checkCurrentColor() -> UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return colorPickerView.currentColor.shouldStatusBarDark() ? .darkContent : .lightContent
        } else {
            return colorPickerView.currentColor.shouldStatusBarDark() ? .default : .lightContent
        }
    }

    
    private func addGestureRecognisers() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(backgroundViewTapped(_:)))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func backgroundViewTapped(_ recognizer: UITapGestureRecognizer) {
        showColorPickerView()
    }
    
    func showColorPickerView() {
        tapLabel.fadeView(0.0, 0.4, hidden: colorPickerView.isHidden)
        colorPickerView.fadeView(0.0, 0.5, hidden: !colorPickerView.isHidden)
        colorPickerView.updateColors(with: backgroundView.backgroundColor ?? UIColor.green)
    }
    
    private func updateLayout() {
        let side = min(self.view.frame.height, self.view.frame.width)
        let constant = side > 414 ? side * 0.6 : side
        colorPickerView.widthAnchor.constraint(equalToConstant: constant).isActive = true
        colorPickerView.heightAnchor.constraint(equalToConstant: constant).isActive = true
        didUpdateLayout = true
    }
    
    private func getDefaultColor() {
        if let color = defaults.value(forKey: defaultColorKey) as? String {
            defaultColor = UIColor(hex: color)
        } else {
            defaultColor = UIColor(hex: "#00ff00ff")
            saveDefaultColor("#00ff00ff")
        }
    }
    
    private func saveDefaultColor(_ color: String) {
        defaults.set(color, forKey: defaultColorKey)
    }
    
}

extension ViewController: ColorPickerViewDelegate {
    
    func changeColor(_ color: UIColor) {
        changeStatusBarStyle(for: color)
        backgroundView.backgroundColor = color
        tapLabel.textColor = color.maxContrast()
    }
    
    func undoColor(_ color: UIColor) {
        colorPickerView.currentColor = color
        changeStatusBarStyle(for: color)
        backgroundView.backgroundColor = color
        tapLabel.textColor = color.maxContrast()
        saveDefaultColor(color.hexRGBA())
    }
    
    func applyColor(_ color: UIColor) {
        saveDefaultColor(color.hexRGBA())
    }

    func changeStatusBarStyle(for color: UIColor) {
        if shouldStatusBarBeDark != color.shouldStatusBarDark() {
            shouldStatusBarBeDark = color.shouldStatusBarDark()
        }
    }
    
    func hideColorPickerView() {
        showColorPickerView()
    }
    
}

