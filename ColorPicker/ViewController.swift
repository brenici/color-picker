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
    @IBOutlet weak var colorPickerWidthConstraint: NSLayoutConstraint!
    
    let defaults = UserDefaults.standard
    let defaultColorKey = "defaultColor"
    var defaultColor = UIColor.green
    var didUpdateLayout = false
    var shouldStatusBarBeDark = true { didSet { layoutStatusBar() } }
    override var preferredStatusBarStyle: UIStatusBarStyle { return toggleStatusBarStyle() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorPickerView.delegate = self
        addGestureRecognisers()
        setupColors()
    }
    
    private func setupColors() {
        getDefaultColor()
        backgroundView.backgroundColor = defaultColor
        toggleStatusBarStyle(for: defaultColor)
        tapLabel.textColor = defaultColor.maxContrast()
        colorPickerView.setupColorPicker(with: defaultColor)
    }

    // MARK: - LAYOUT

    override func viewDidLayoutSubviews() {
        updateLayout()
    }
    
    private func updateLayout() {
        if !didUpdateLayout {
            let side = min(self.view.frame.height, self.view.frame.width)
            colorPickerView.screenWidth = side > 414 ? side * 0.6 : side
            colorPickerWidthConstraint.constant = side > 414 ? side * 0.6 : side
        }
        didUpdateLayout = true
    }
    
    func toggleColorPickerView() {
        tapLabel.fadeView(0.0, 0.4, hidden: colorPickerView.isHidden)
        colorPickerView.fadeView(0.0, 0.5, hidden: !colorPickerView.isHidden)
        colorPickerView.updateColors(with: backgroundView.backgroundColor ?? UIColor.green)
    }
    
    // MARK: - GESTURES

    private func addGestureRecognisers() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(backgroundViewTapped(_:)))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func backgroundViewTapped(_ recognizer: UITapGestureRecognizer) {
        toggleColorPickerView()
    }
    
    // MARK: - STATUS BAR STYLE
    
    private func layoutStatusBar() {
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    private func toggleStatusBarStyle() -> UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return colorPickerView.currentColor.shouldStatusBarDark() ? .darkContent : .lightContent
        } else {
            return colorPickerView.currentColor.shouldStatusBarDark() ? .default : .lightContent
        }
    }
    
    // MARK: - USER DEFAULTS

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

// MARK: - EXTENSIONS

extension ViewController: ColorPickerViewDelegate {
    
    func changeColor(_ color: UIColor) {
        toggleStatusBarStyle(for: color)
        backgroundView.backgroundColor = color
        tapLabel.textColor = color.maxContrast()
    }
    
    func undoColor(_ color: UIColor) {
        colorPickerView.currentColor = color
        toggleStatusBarStyle(for: color)
        backgroundView.backgroundColor = color
        tapLabel.textColor = color.maxContrast()
        saveDefaultColor(color.hexRGBA())
    }
    
    func applyColor(_ color: UIColor) {
        saveDefaultColor(color.hexRGBA())
    }

    func toggleStatusBarStyle(for color: UIColor) {
        if shouldStatusBarBeDark != color.shouldStatusBarDark() {
            shouldStatusBarBeDark = color.shouldStatusBarDark()
        }
    }
    
    func hideColorPickerView() {
        toggleColorPickerView()
    }
    
}
