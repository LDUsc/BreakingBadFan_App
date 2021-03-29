//
//  FilterView.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 03/03/2021.
//

import UIKit

class FilterView: UIView {
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.layer.borderWidth = 2.5
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 10
    }
}
