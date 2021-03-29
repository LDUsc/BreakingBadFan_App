//
//  CustomNavigationBar.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 03/03/2021.
//

import UIKit

class CustomNavigationBar: UINavigationBar {
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        prefersLargeTitles = true
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        isTranslucent = true
    }
}
