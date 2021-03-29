//
//  FilterTableView.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 03/03/2021.
//

import UIKit

class FilterTableView: UITableView {
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 0.5
    }
}
