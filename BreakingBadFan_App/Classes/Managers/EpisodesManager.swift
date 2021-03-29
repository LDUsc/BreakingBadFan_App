//
//  EpisodesManager.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 25/02/2021.
//

import UIKit

class EpisodesManager {
    
    static private let apiManager = APIManager()
    static var seasonNumbers = [String]()
    static var episodes = [Episode]()
    static var episodesData = [SeasonSection]()
    
    static var charactersInEpisode: [String] {
        var characters = [String]()
        for episode in episodes {
            characters.append(contentsOf: episode.characters)
        }
        return characters.removeDuplicates().sorted()
    }
}

// MARK: - Helpers

extension EpisodesManager {
    
    static func loadEpisodes(completion: @escaping (Result<Void, APIError>) -> Void) {
        apiManager.getEpisodesFromAPI { result in
            switch result {
            case .success(let episodes):
                self.episodes = episodes
                reloadEpisodesData()
                setSeasonNumbers()
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func filterEpisodesData(
        seasons: [Int]?,
        fromDate: String?,
        toDate: String?,
        characters: [String]?
    ) {
        reloadEpisodesData()
        
        let filteredEpisodes = applyFilter(
            seasons: seasons,
            fromDate: fromDate,
            toDate: toDate,
            characters: characters
        )
        
        episodesData = sortEpisodesToSeasons(episodes: filteredEpisodes)
    }
    
    static func reloadEpisodesData() {
        episodesData = sortEpisodesToSeasons(episodes: EpisodesManager.episodes)
    }
    
    static func setSeasonNumbers() {
        seasonNumbers = episodesData.map {$0.season }
    }
}

// MARK: - Filter

private extension EpisodesManager {
    
    static func applyFilter(
        seasons: [Int]?,
        fromDate: String?,
        toDate: String?,
        characters: [String]?
    ) -> [Episode] {
        
        let firstFilter = filterBySeasons(seasons, episodesToFilter: self.episodes)
        let secondFilter = filterFromDate(fromDate: fromDate, episodesToFilter: firstFilter)
        let thirdFilter = filterToDate(toDate: toDate, episodesToFilter: secondFilter)
        let fourthFilter = filterByCharacters(characters: characters, episodesToFilter: thirdFilter)
        return fourthFilter.sorted { $0.date < $1.date }.removeDuplicates()
    }
    
    static func filterBySeasons(_ seasonsIndex: [Int]?, episodesToFilter: [Episode]) -> [Episode] {
        guard let seasonsIndex = seasonsIndex else {
            return episodesToFilter }
        
        var filteredBySeasons = [Episode]()
        
        for season in seasonsIndex {
            filteredBySeasons.append(contentsOf: episodesData[season].episodes )
        }
        
        return originalIfEmpty(array: filteredBySeasons, original: episodesToFilter)
    }
    
    static func filterFromDate(fromDate: String?, episodesToFilter: [Episode]) -> [Episode] {
        guard
            let fromDate = fromDate
        else {
            return episodesToFilter
        }
        
        let filteredFromDate = episodesToFilter.filter {
            $0.date >= fromDate.convertToDate()
        }
        
        return originalIfEmpty(array: filteredFromDate, original: episodesToFilter)
    }
    
    static func filterToDate(toDate: String?, episodesToFilter: [Episode]) -> [Episode] {
        guard
            let toDate = toDate
        else {
            return episodesToFilter
        }
        
        let filteredToDate = episodesToFilter.filter {
            $0.date <= toDate.convertToDate()
        }
        
        return originalIfEmpty(array: filteredToDate, original: episodesToFilter)
    }
    
    static func filterByCharacters(characters: [String]?, episodesToFilter: [Episode]) -> [Episode] {
        guard
            let characters = characters,
            characters.isNotEmpty
        else {
            return episodesToFilter
        }
        
        var filteredByCharacters = [Episode]()
        
        for episode in episodesToFilter {
            for character in characters {
                if episode.characters.contains(character) {
                    filteredByCharacters.append(episode)
                }
            }
        }
        
        return originalIfEmpty(array: filteredByCharacters, original: episodesToFilter)
    }
    
    static func originalIfEmpty(array: [Episode], original: [Episode] ) -> [Episode] {
        guard array.isNotEmpty else {
             return original
        }
        return array
    }
    
    static func sortEpisodesToSeasons(episodes: [Episode]) -> [SeasonSection] {
        let groupedEpisodesDictionary = Dictionary(grouping: episodes) { $0.season }
        let keys = groupedEpisodesDictionary.keys.sorted { $0 < $1 }
        
        return keys.map{ SeasonSection(
            season: String($0) ,
            episodes: groupedEpisodesDictionary[$0]!)}
    }
}
