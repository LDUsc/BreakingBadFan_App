//
//  Array.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 25/02/2021.
//

import Foundation

extension Array {
    
    var isNotEmpty: Bool {
        !isEmpty
    }
}

extension Array where Element: Equatable {
    
    func removeDuplicates() -> [Element] {
        var array = [Element]()
        
        for value in self {
            if array.contains(value) == false {
                array.append(value)
            }
        }
        return array
    }
}
