//
//  CharactersManager.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 26/02/2021.
//

import Foundation

class CharactersManager {
    
    static private let apiManager = APIManager()
    static var characters = [Character]()
    static var charactersData = [CharactersSection]()
    
    static func loadCharacters(completion: @escaping (Result<Void, APIError>) -> Void) {
        apiManager.getCharactersFromAPI { result in
            switch result {
            case .success(let charactersResult):
                characters = charactersResult
                charactersData = sortCharactersToSections(characters: charactersResult)
                completion(.success(()))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    static func getSpecificCharacter(fullName: String?) -> Character? {
        guard let fullName = fullName else {
            return nil
        }
        if let characterByFull = getCharacterByFullName(fullName: fullName) {
            return characterByFull
        } else if let characterByLast = getCharacterByLastName(fullName: fullName) {
            return characterByLast
        } else {
            return getCharacterByFirstName(fullName: fullName)
        }
    }
    
    static func reloadCharactersData() {
        charactersData = sortCharactersToSections(characters: characters)
    }
    
    static func filterCharactersData(lifeStatus: String?, seasons: [Int]?) {
        let firstFilter =  filterCharactersBySeasonAppearance(seasons: seasons)
        let secondFilter = filterCharactersByLifeStatus(lifeStatus: lifeStatus, charactersToFilter: firstFilter).removeDuplicates()
        
        self.charactersData = sortCharactersToSections(characters: secondFilter)
    }
}

// MARK: - Filters

private extension CharactersManager {
    
    static func filterCharactersBySeasonAppearance(seasons: [Int]?) -> [Character] {
        guard
            let seasons = seasons,
            seasons.isNotEmpty
        else {
            return characters
        }
        var filteredBySeasons = [Character]()
        for season in seasons {
            for character in characters {
                if character.seasons.contains(season + 1){
                    filteredBySeasons.append(character)
                }
            }
        }
        return filteredBySeasons
    }
    
    static func filterCharactersByLifeStatus(
        lifeStatus: String?,
        charactersToFilter: [Character]
    ) -> [Character] {
        guard let lifeStatus = lifeStatus else {
            return charactersToFilter
        }
        let filteredByLifeStatus = charactersToFilter.filter { $0.lifeStatus == lifeStatus }
        return filteredByLifeStatus
    }
    
    static func getCharacterByFullName(fullName: String) -> Character? {
        let character = CharactersManager.characters.first(where: { $0.name == fullName })
        return character
    }
    
    static func getCharacterByLastName(fullName: String) -> Character? {
        let characterLastName = fullName.lastWord()
        let character = CharactersManager.characters.first(where: { $0.name.lastWord() == characterLastName })
        return character
    }
    
    static func getCharacterByFirstName(fullName: String) -> Character? {
        let characterFirstName = fullName.firstWord()
        let character = CharactersManager.characters.first(where: { $0.name.lastWord() == characterFirstName })
        return character
    }
    
    static func sortCharactersToSections(characters: [Character]) -> [CharactersSection] {
        let groupedCharactersDictionary = Dictionary(grouping: characters) { $0.name.prefix(1) }
        let keys = groupedCharactersDictionary
            .keys
            .sorted { $0 < $1 }
        
        return keys.map {
            CharactersSection(
                sectionLetter: String($0) ,
                characters: groupedCharactersDictionary[$0]!)
        }
    }
}
