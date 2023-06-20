//
//  FavouritesManager.swift
//  Technical-test
//
//  Created by Vladyslav Poznyak on 20.06.2023.
//

import Foundation

enum FavouritesManager {
    private static let defaultsKey = "com.tech-test.favouritesSymbols"
    private static var storage: PersistantStorage = UserDefaults.standard
    
    static let updateNotificationName = Notification.Name("com.tech-test.updateFavouritesNotification")
    
    static var favouriteSymbols: [String]? {
        get {
            storage.value(forKey: defaultsKey) as? [String]
        }
    }
    
    static func toggleFavourite(_ symbol: String) {
        var favourites = Set(favouriteSymbols ?? [])
        if favourites.contains(symbol) {
            favourites.remove(symbol)
        } else {
            favourites.insert(symbol)
        }
        storage.set(Array(favourites), forKey: defaultsKey)
        NotificationCenter.default.post(name: updateNotificationName, object: nil)
    }
    
    static func useStorage(_ storage: PersistantStorage) {
        FavouritesManager.storage = storage
    }
}
