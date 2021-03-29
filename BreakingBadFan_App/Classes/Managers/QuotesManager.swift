//
//  QuotesManager.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 28/02/2021.
//

import Foundation

class QuotesManager {
    
    static private let apiManager = APIManager()
    static var randomQuote = [Quote]()
    static var quotesData = [QuotesSection]()
    
    static private var allFavoriteQuotes: [FavoriteQuote] {
        guard let favoriteQuotes = FavoriteQuotesDatabase.favoriteQuotes else {
            return []
        }
        return favoriteQuotes
    }
    
    static var personalFavoriteQuotes: [Quote] {
        let username = UserDefaultsManager.currentlyLoggedInAccount?.username 
        let personalFavoriteQuotes = allFavoriteQuotes
            .filter { $0.username == username }
            .map { $0.quote }
        
        return personalFavoriteQuotes.removeDuplicates()
    }
    
    static var topThreeFavoriteQuotes: [Quote] {
        var quotesDictionary = [Quote: Int]()
        for favoriteQuote in allFavoriteQuotes {
            if quotesDictionary[favoriteQuote.quote] != nil {
                quotesDictionary[favoriteQuote.quote]! += 1
            } else {
                quotesDictionary[favoriteQuote.quote] = 1
            }
        }
        let topThreeQuotes = quotesDictionary
            .sorted(by: { $0.value > $1.value })
            .prefix(3)
            .map { $0.key }
        return topThreeQuotes
    }
}

// MARK: - Helpers

extension QuotesManager {
    
    static func loadQuotesForTableView() {
        quotesData =  [
            QuotesSection(title: "Random Quote:", quotes: QuotesManager.randomQuote),
            QuotesSection(title: "My Favorites:", quotes: QuotesManager.personalFavoriteQuotes),
            QuotesSection(title: "Top 3 Favorite", quotes: QuotesManager.topThreeFavoriteQuotes)
        ]
    }
    
    static func getRandomQuote(completion: @escaping (Result<Void, APIError>) -> Void) {
        apiManager.getRandomQuoteFromAPI { result in
            switch result {
            case .success(let randomQuote):
                self.randomQuote = randomQuote
                loadQuotesForTableView()
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func isQuoteFavorite(_ quote: Quote, completion: @escaping BoolCompletion) {
        guard personalFavoriteQuotes.contains( quote ) else {
            completion(false)
            return
        }
        completion(true)
    }
    
    static func saveQuoteAsFavorite(_ quote: Quote) {
        guard let username = UserDefaultsManager.currentlyLoggedInAccount?.username else {
            print("no username")
            return
        }
    FavoriteQuotesDatabase.saveQuote(quote, username: username)
    }
    
    static func removeQuoteFromFavorite(_ quote: Quote) {
        FavoriteQuotesDatabase.deleteQuote(quote)
    }
    
    static func getQuoteCount(_ quote: Quote) -> Int {
        return allFavoriteQuotes.filter { $0.quote == quote }.count
    }
}
