//
//  ViewController.swift
//  ColorPicker
//
//  Created by Emilian Brenici on 26/04/2020.
//  Copyright © 2020 Emilian Brenici. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var colorPickerView: UIView!
    
    let fileName = (#file as NSString).lastPathComponent
    var didUpdateLayout = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("File: \(fileName), func: \(#function), line: \(#line)")
        colorPickerView.translatesAutoresizingMaskIntoConstraints = false
    }

    override func viewWillLayoutSubviews() {
        print("File: \(fileName), func: \(#function), line: \(#line)")
        if !didUpdateLayout {
            updateLayout()
        }
    }
    
    private func updateLayout() {
        print("File: \(fileName), func: \(#function), line: \(#line)")
        let side = min(self.view.frame.height, self.view.frame.width)
        let constant = side > 414 ? side * 0.6 : side
        print(constant)
        colorPickerView.widthAnchor.constraint(equalToConstant: constant).isActive = true
        colorPickerView.heightAnchor.constraint(equalToConstant: constant).isActive = true
        didUpdateLayout = true
    }
    
}
