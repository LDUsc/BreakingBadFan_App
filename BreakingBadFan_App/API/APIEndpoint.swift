//
//  APIEndpoint.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 25/02/2021.
//

import Foundation

enum APIEndpoint {
    case allEpisodes(forSeries: String)
    case allCharacters(forSeries: String)
    case specificCharacterQuotes(characterName: String)
    case randomQuote
    
    var url: URL? {
        switch self {
        case .allEpisodes(let series):
            let queryItem = URLQueryItem(name: SeriesQueryKey, value: series)
            return makeURL(endpoint: "/api/episodes", queryItems: [queryItem])
        case .allCharacters(let series):
            let queryItem = URLQueryItem(name: SeriesCategoryQueryKey, value: series)
            return makeURL(endpoint: "/api/characters", queryItems: [queryItem])
        case .specificCharacterQuotes(let name):
            let queryItem = URLQueryItem(name: AuthorQueryKey, value: name)
            return makeURL(endpoint: "/api/quote", queryItems: [queryItem])
        case .randomQuote:
            return makeURL(endpoint: "/api/quote/random")
        }
    }
}

// MARK: - Helpers

private extension APIEndpoint {
    
    var SeriesQueryKey: String {
        "series"
    }
    
    var SeriesCategoryQueryKey: String {
        "category"
    }
    
    var AuthorQueryKey: String {
        "author"
    }
    
    var BaseURL: String {
        "https://www.breakingbadapi.com"
    }
    
    func makeURL(endpoint: String, queryItems: [URLQueryItem]? = nil) -> URL? {
        let urlString = BaseURL + endpoint
        
        guard let queryItems = queryItems else {
            return URL(string: urlString)
        }
        
        var components = URLComponents(string: urlString)
        components?.queryItems = queryItems
        return components?.url
    }
}
