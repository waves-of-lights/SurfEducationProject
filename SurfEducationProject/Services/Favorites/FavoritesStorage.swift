//
//  FavoritesStorage.swift
//  surf
//
//  Created by Anastasia Anisimova on 21.08.2022.
//

import Foundation

struct FavoritesStorage {
    
}

extension FavoritesStorage {
    
    static func set(_ toFavorite: Bool, postId: String) {
        var currentFavorites = UserDefaults.standard.array(forKey: "favorites") as? [String] ?? Array<String>()
        
        if !currentFavorites.contains(postId) && toFavorite {
            currentFavorites.append(postId)
            UserDefaults.standard.set(currentFavorites, forKey: "favorites")
        } else {
            guard let index = currentFavorites.firstIndex(of: postId) else { return }
            currentFavorites.remove(at: index)
            UserDefaults.standard.set(currentFavorites, forKey: "favorites")
        }
    }
    
    static func validate(postId: String) -> Bool {
        return (UserDefaults.standard.array(forKey: "favorites") as? [String] ?? Array<String>()).contains(postId)
    }
}

