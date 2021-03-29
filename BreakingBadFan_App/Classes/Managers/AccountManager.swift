//
//  AccountManager.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 24/02/2021.
//

struct AccountManager {

    static func login(username: String?, password: String?) throws {
        guard let accounts = UserDefaultsManager.accounts else {
            throw AccountManagerError.accountNotFound
        }
        for account in accounts where account.username == username {
            try checkIfPasswordMatchesSaved(password, username: account.username)
            setLoggedInAccount(account)
            return
        }
        throw AccountManagerError.accountNotFound
    }
    
    static func registerAccount(
        username: String?,
        password: String?,
        passwordConfirmation : String?
    ) throws {
        let username = try validateUsername(username)
        let password = try validatePassword(password, passwordConfirmation: passwordConfirmation)
        
        let account = Account(username: username)
        UserDefaultsManager.saveAccount(account, withPassword: password)
        UserDefaultsManager.currentlyLoggedInAccount = account
    }
}

// MARK: - Login Validation

private extension AccountManager {
    
    static func checkIfPasswordMatchesSaved(_ password: String?, username: String) throws {
        guard password == UserDefaultsManager.getPassword(username: username) else {
            throw AccountManagerError.wrongPassword
        }
    }
    
    static func setLoggedInAccount(_ account: Account) {
        UserDefaultsManager.currentlyLoggedInAccount = account
    }
}


// MARK: - Registry Validation

private extension AccountManager {
    
    // MARK: - Username
    
    static func validateUsername(_ username: String?) throws -> String {
        guard
            let username = username,
            username.isNotEmpty
        else {
            throw AccountManagerError.missingUsername
        }
        
        guard !isUsernameTaken(username) else {
            throw AccountManagerError.usernameAlreadyExists
        }
        return username
    }
    
    static func isUsernameTaken(_ username: String) -> Bool {
        guard let accounts = UserDefaultsManager.accounts else { return false }
        
        return accounts.contains { account -> Bool in
            account.username == username
        }
    }
    
    // MARK: - Password
    
    static func validatePassword(_ password: String?, passwordConfirmation: String?) throws -> String {
        guard
            let password = password,
            password.isNotEmpty
        else {
            throw AccountManagerError.passwordMissing
        }
        
        guard password == passwordConfirmation else {
            throw AccountManagerError.passwordsDontMatch
        }
        
        guard isPasswordSafe(password) else {
            throw AccountManagerError.passwordNotSafe
        }
        
        return password
    }
    
    static func isPasswordSafe(_ password: String) -> Bool {
        guard
            password.count >= 8,
            password.containsLetters,
            password.containsNumbers,
            password.containsLowercase,
            password.containsUppercase,
            password.cointainsSpecialCharacters
        else {
            return false
        }
        return true
    }
}
