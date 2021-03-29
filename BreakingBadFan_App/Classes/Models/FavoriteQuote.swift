//
//  FavoriteQuote.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 01/03/2021.
//

import Foundation

struct FavoriteQuote: Codable, Hashable {
    
    let username: String
    let quote: Quote
    
    static func == (lhs: FavoriteQuote, rhs: FavoriteQuote) -> Bool {
        return lhs.quote.id == rhs.quote.id
    }
}
