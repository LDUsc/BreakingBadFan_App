//
//  GetQuotesResponse.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 28/02/2021.
//

import Foundation

struct Quote: Codable, Hashable {
    
    let id: Int
    let quote: String
    let character: String
    
    enum CodingKeys: String, CodingKey {
        case id = "quote_id"
        case quote
        case character = "author"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        quote = try container.decode(String.self, forKey: .quote)
        character = try container.decode(String.self, forKey: .character)
    }
}
