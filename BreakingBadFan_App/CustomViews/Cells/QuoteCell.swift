//
//  QuoteCell.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 28/02/2021.
//

import UIKit

class QuoteCell: UITableViewCell {
    
    enum QuoteStatus {
        case favorite
        case notFavorite
    }
    
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var favoriteQuoteIcon: UIImageView!
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if (highlighted) {
            self.backgroundColor = #colorLiteral(red: 0.3921568627, green: 0.6156862745, blue: 0.4, alpha: 1)
        } else {
            self.backgroundColor = .clear
        }
    }
    
    private let symbolConfiguration = {
        return UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 20))
    }
    
    func configureFavoriteQuoteIcon(isFavorite: Bool) {
        switch isFavorite {
        case true:
            favoriteQuoteIcon.image = UIImage(systemName: "heart.fill", withConfiguration: symbolConfiguration())
            favoriteQuoteIcon.tintColor = .systemPink
        case false:
            favoriteQuoteIcon.image = UIImage(systemName: "heart", withConfiguration: symbolConfiguration())
            favoriteQuoteIcon.tintColor = .systemPink
        }
    }
}
