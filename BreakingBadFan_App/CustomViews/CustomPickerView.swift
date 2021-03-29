//
//  CustomPickerView.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 03/03/2021.
//

import UIKit

class CustomPickerView: UIPickerView {
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setValue(UIColor.white, forKeyPath: "textColor")
        layer.cornerRadius = 5
    }
}
