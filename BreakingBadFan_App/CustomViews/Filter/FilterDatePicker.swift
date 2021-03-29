//
//  FilterDatePicker.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 25/02/2021.
//

import UIKit

class FilterDatePicker: UIDatePicker {
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.datePickerMode = .date
        self.preferredDatePickerStyle = .wheels
        
        self.backgroundColor = .white
        self.layer.borderWidth = 0.5
    }
}
