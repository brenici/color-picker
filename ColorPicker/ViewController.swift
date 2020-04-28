//
//  ViewController.swift
//  ColorPicker
//
//  Created by Emilian Brenici on 26/04/2020.
//  Copyright © 2020 Emilian Brenici. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let fileName = (#file as NSString).lastPathComponent // DEBUG ONLY
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var colorPickerView: ColorPickerView!
        
    let defaults = UserDefaults.standard
    let defaultColorKey = "defaultColor"
    var didUpdateLayout = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("File: \(fileName), func: \(#function), line: \(#line)")
        colorPickerView.delegate = self
        colorPickerView.translatesAutoresizingMaskIntoConstraints = false
    }

    override func viewWillLayoutSubviews() {
        print("File: \(fileName), func: \(#function), line: \(#line)")
        if !didUpdateLayout {
            updateLayout()
        }
    }
    
    private func updateLayout() { // Auto Layout
        print("File: \(fileName), func: \(#function), line: \(#line)")
        let side = min(self.view.frame.height, self.view.frame.width)
        let constant = side > 414 ? side * 0.6 : side
        print(constant)
        colorPickerView.widthAnchor.constraint(equalToConstant: constant).isActive = true
        colorPickerView.heightAnchor.constraint(equalToConstant: constant).isActive = true
        didUpdateLayout = true
    }
    
    private func getDefaultColor() -> String { // Get Persisted Color Hex Value
        print("File: \(fileName), func: \(#function), line: \(#line)")
        if let color = defaults.value(forKey: defaultColorKey) as? String {
            return color
        }
        saveDefaultColor("#00ff00ff")
        return "#00ff00ff"
    }
    
    private func saveDefaultColor(_ color: String) { // Persist Color Hex Value
        print("File: \(fileName), func: \(#function), line: \(#line)")
        defaults.set(color, forKey: defaultColorKey)
    }
    
}

extension ViewController: ColorPickerViewDelegate {
    
    func changeColor(_ color: UIColor) { // change background color - instantlyChangeColors
        backgroundView.backgroundColor = color
    }
    
    func undoColor(_ color: UIColor) { // undo color and close controls
        backgroundView.backgroundColor = color
        
    }
    
    func applyColor(_ color: UIColor) { // apply color and close controls
        backgroundView.backgroundColor = color
        saveDefaultColor(color.hexRGBA())
    }
    
    func colorChanged(_ color: UIColor) { //
        self.view.backgroundColor = color
        backgroundView.backgroundColor = color
        saveDefaultColor(color.hexRGBA())
    }
    
    func showColorPickerView(_ state: Bool, _ color: UIColor) {

    }
    
}

