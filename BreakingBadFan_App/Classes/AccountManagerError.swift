//
//  AccountManagerError.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 24/02/2021.
//

enum AccountManagerError: Error {
    case missingValues
    case missingUsername
    
    case passwordMissing
    case passwordInvalid
    case wrongPassword
    case passwordsDontMatch
    case passwordNotSafe
    
    case accountNotFound
    case usernameAlreadyExists
    
    var errorDescription: String {
        switch self {
        case .missingValues:
            return "Missing required values!"
        case .missingUsername:
            return "Missing username!"
        case.passwordMissing:
            return "Missing password!"
        case .wrongPassword:
            return "Password is incorrect!"
        case .passwordInvalid:
            return "Password is invalid!"
        case .passwordsDontMatch:
            return "Passwords do not match!"
        case .passwordNotSafe:
            return "Password is not safe. Please make sure password contains at least one special character, lowercase and uppercase characters and a number"
        case .usernameAlreadyExists:
            return "This username is already taken!"
        case .accountNotFound:
            return "Account with this username was not found!"
        }
    }
}
