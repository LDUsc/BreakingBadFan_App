//
//  GetCharactersResponse.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 26/02/2021.
//
import Foundation

struct Character: Codable, Hashable {
    
    let characterId: Int
    let name: String
    let birthday: String
    let image: String
    let seasons: [Int]
    let lifeStatus: String
    
    enum CodingKeys: String, CodingKey {
        case characterId = "char_id"
        case name
        case birthday
        case image = "img"
        case seasons = "appearance"
        case lifeStatus = "status"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        characterId = try container.decode(Int.self, forKey: .characterId)
        name = try container.decode(String.self, forKey: .name)
        birthday = try container.decode(String.self, forKey: .birthday)
        image = try container.decode(String.self, forKey: .image)
        seasons = try container.decode([Int].self, forKey: .seasons)
        lifeStatus = try container.decode(String.self, forKey: .lifeStatus)
    }
}
