//
//  DateTextField.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 25/02/2021.
//

import UIKit

class FilterDateTextField: UITextField {
    
    let screenWidth = UIScreen.main.bounds.width
    
    override func didMoveToSuperview() {
        setAccessoryView()
    }
    
    func setAccessoryView() {
        let toolBar = UIToolbar(
            frame: CGRect(
                x: 0.0,
                y: 0.0,
                width: screenWidth,
                height: 44.0
            )
        )
        
        let flexible = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        let cancelButton = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: nil,
            action: #selector(CancelTapped)
        )
        
        let doneBarButton = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: target,
            action: #selector(doneTapped)
        )
        
        toolBar.setItems([cancelButton, flexible, doneBarButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    
    @objc func CancelTapped() {
        self.resignFirstResponder()
    }
    
    @objc func doneTapped() {
        if let datePicker = self.inputView as? FilterDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MM - dd - yyyy"
            self.text = dateformatter.string(from: datePicker.date)
        }
        self.resignFirstResponder()
    }
}
