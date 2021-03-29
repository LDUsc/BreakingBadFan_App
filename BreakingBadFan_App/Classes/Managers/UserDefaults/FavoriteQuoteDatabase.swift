//
//  FavoriteQuoteDatabase.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 05/03/2021.
//

import Foundation

class FavoriteQuotesDatabase: UserDefaultsManager {
    
    static func saveQuote(_ quote: Quote, username: String) {
        guard favoriteQuotes != nil else {
            favoriteQuotes = [FavoriteQuote(username: username, quote: quote)]
            return
        }
        favoriteQuotes?.append(FavoriteQuote(username: username, quote: quote))
    }
    
    static func deleteQuote(_ quote: Quote) {
        guard let username = currentlyLoggedInAccount?.username else {
            print("User doesn't exist")
            return
        }
        if let index = favoriteQuotes?.firstIndex(where: { $0.username == username && $0.quote == quote})  {
            favoriteQuotes?.remove(at: index)
        }
    }
    
    static var favoriteQuotes: [FavoriteQuote]? {
        get {
            guard let encodedQuotes = userDefaults.object(forKey: UserDefaultsKey.favoriteQuotes) as? Data else {
                return nil
            }
            return try? JSONDecoder().decode([FavoriteQuote].self, from: encodedQuotes)
        } set {
            let encodedQuotes = try? JSONEncoder().encode(newValue)
            userDefaults.set(encodedQuotes, forKey: UserDefaultsKey.favoriteQuotes)
        }
    }
}
