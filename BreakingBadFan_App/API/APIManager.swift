//
//  APIManager.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 25/02/2021.
//

import Foundation

struct APIManager {
    
    private var session: URLSession {
        return URLSession(configuration: .default)
    }
    
    enum BreakingBadSeries {
        static let breakingBad = "Breaking+Bad"
        static let betterCallSaul = "Better+Call+Saul"
    }
}

// MARK: - API Calls

extension APIManager {
    
    // MARK: - Episodes
    
    func getEpisodesFromAPI(_ completion: @escaping (Result<[Episode], APIError>) -> Void) {
        guard let url = APIEndpoint.allEpisodes(forSeries: BreakingBadSeries.breakingBad).url else {
            completion(.failure(.failedURLCreation))
            return
        }
        
        getData(url: url, decodingTo: [Episode].self) { result in
            switch result {
            case .success(let episodes):
                completion(.success(episodes))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Characters
    
    func getCharactersFromAPI(_ completion: @escaping (Result<[Character], APIError>) -> Void) {
        guard let url = APIEndpoint.allCharacters(forSeries: BreakingBadSeries.breakingBad).url else {
            completion(.failure(.failedURLCreation))
            return
        }
        
        getData(url: url, decodingTo: [Character].self) { result in
            switch result {
            case .success(let characters):
                completion(.success(characters))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Quotes
    
    
    func getSpecificCharacterQuotesFromAPI(
        character name: String,
        _ completion: @escaping (Result<[Quote], APIError>) -> Void
    ) {
        guard let url = APIEndpoint.specificCharacterQuotes(characterName: name).url else {
            completion(.failure(.failedURLCreation))
            return
        }
        
        getData(url: url, decodingTo: [Quote].self) { result in
            switch result {
            case .success(let quotes):
                completion(.success(quotes))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getRandomQuoteFromAPI(_ completion: @escaping (Result<[Quote], APIError>) -> Void) {
        guard let url = APIEndpoint.randomQuote.url else {
            completion(.failure(.failedURLCreation))
            return
        }
        
        getData(url: url, decodingTo: [Quote].self) { result in
            switch result {
            case .success(let quotes):
            completion(.success(quotes))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private extension APIManager {
    
    func getData <T: Decodable>(
        url: URL,
        decodingTo: T.Type,
        _ completion: @ escaping (Result<T, APIError>) -> Void
    ) {
        session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let dataResponse = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(dataResponse))
                    } catch {
                        completion(.failure(.unexpectedDataFormat))
                    }
                } else {
                    completion(.failure(.failedRequest))
                }
            }
        }.resume()
    }
}
