//
//  CustomButton.swift
//  CodeAcademyApp
//
//  Created by Lukas Uscila Dainavicius on 04/02/2021.
//

import UIKit

final class CustomButton: UIButton {
    
    override func didMoveToSuperview() {
        configureButton()
    }
    
    private func configureButton() {
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 0.3
        self.titleLabel?.font = .boldSystemFont(ofSize: 15)
        self.backgroundColor = #colorLiteral(red: 1, green: 0.8025540139, blue: 0, alpha: 1)
    }
    
    func isAccesible(isAccesible: Bool) {
        guard
            isAccesible
        else {
            layer.opacity = 0.5
            isEnabled = false
            return
        }
        layer.opacity = 1
        isEnabled = true
    }
}
