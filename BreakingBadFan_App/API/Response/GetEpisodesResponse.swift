//
//  GetEpisodesResponse.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 25/02/2021.
//

import Foundation

struct Episode: Codable, Hashable {
    
    let season: String
    let episodeId: Int
    let episode: String
    let title: String
    let characters: [String]
    let airDate: String
    
    var date: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter.date(from: airDate) ?? .distantPast
    }
    
    enum CodingKeys: String, CodingKey {
        case season
        case episode
        case title
        case characters
        case airDate = "air_date"
        case episodeId = "episode_id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let seasonStr = try container.decode(String.self, forKey: .season)
        season = seasonStr.trimmingCharacters(in: .whitespaces)
        episodeId = try container.decode(Int.self, forKey: .episodeId)
        episode = try container.decode(String.self, forKey: .episode)
        title = try container.decode(String.self, forKey: .title)
        characters = try container.decode([String].self, forKey: .characters)
        airDate = try container.decode(String.self, forKey: .airDate)
    }
}
