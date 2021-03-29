//
//  FilterCell.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 25/02/2021.
//

import UIKit

class FilterCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    
    func configureCell(name: String) {
        nameLabel.text = name
    }
}
