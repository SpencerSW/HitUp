//
//  Defaults.swift
//  MessageMe
//
//  Created by Spencer McLaughlin on 2/14/24.
//

import Foundation

extension UserDefaults {
    
    private static let isLoggedInKey = "isLoggedIn"
    
    var isLoggedIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaults.isLoggedInKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.isLoggedInKey)
        }
    }
    
    static func updateLoggedInStatus(_ isLoggedIn: Bool) {
            UserDefaults.standard.isLoggedIn = isLoggedIn
    }
}
