//
//  String.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 24/02/2021.
//

import Foundation

extension String {
    
    var isNotEmpty: Bool {
        !isEmpty
    }
    
    var containsLetters: Bool {
        return self.rangeOfCharacter(from: .letters) != nil
    }
    
    var containsNumbers: Bool {
        return self.rangeOfCharacter(from: .decimalDigits) != nil
    }
    
    var containsLowercase: Bool {
        return self.rangeOfCharacter(from: .lowercaseLetters) != nil
    }
    
    var containsUppercase: Bool {
        return self.rangeOfCharacter(from: .uppercaseLetters) != nil
    }
    
    var cointainsSpecialCharacters: Bool {
        return self.range(of: ".*[^A-Za-z0-9].*", options: .regularExpression) != nil
    }
    
    func lastWord() -> String? {
        let strArr = self.components(separatedBy: " ")
        return strArr.last
    }
    
    func firstWord() -> String? {
        let strArr = self.components(separatedBy: " ")
        return strArr.first
    }
    
    func convertToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter.date(from: self) ?? .distantPast
    }
}
