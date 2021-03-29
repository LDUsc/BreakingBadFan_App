//
//  UserDefaultsManager.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 24/02/2021.
//

import Foundation

class UserDefaultsManager {
    
    enum UserDefaultsKey {
        static let accounts = "Accounts"
        static let currentUser = "CurrentUser"
        static let favoriteQuotes = "FavoriteQuote"
    }
    
    static let userDefaults = UserDefaults.standard
    private static let keyChain = KeychainSwift()
    
    static func saveAccount(_ account: Account, withPassword password: String) {
        guard accounts != nil else {
            accounts = [account]
            return
        }
        accounts?.append(account)
        savePassword(password, username: account.username)
    }
    
    static var currentlyLoggedInAccount: Account? {
        get {
            guard let encodedCurrentUser = userDefaults.object(forKey: UserDefaultsKey.currentUser) as? Data else {
                return nil
            }
            return try? JSONDecoder().decode(Account.self, from: encodedCurrentUser)
        } set {
            let encodedCurrentUser = try? JSONEncoder().encode(newValue)
            userDefaults.set(encodedCurrentUser, forKey: UserDefaultsKey.currentUser)
        }
    }
    
    static var accounts: [Account]? {
        get {
            guard let encodedAccounts = userDefaults.object(forKey: UserDefaultsKey.accounts) as? Data else {
                return nil
            }
            return try? JSONDecoder().decode([Account].self, from: encodedAccounts)
        } set {
            let encodedAccounts = try? JSONEncoder().encode(newValue)
            userDefaults.set(encodedAccounts, forKey: UserDefaultsKey.accounts)
        }
    }
    
    static func savePassword(_ password: String, username: String) {
        keyChain.set(password, forKey: username)
    }
    
    static func getPassword(username: String) -> String? {
        keyChain.get(username)
    }
}
