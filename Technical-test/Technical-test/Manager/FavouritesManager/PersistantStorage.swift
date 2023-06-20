//
//  PersistantStorage.swift
//  Technical-test
//
//  Created by Vladyslav Poznyak on 20.06.2023.
//

import Foundation

protocol PersistantStorage {
    func value(forKey: String) -> Any?
    func set(_ value: Any?, forKey: String)
}

extension UserDefaults: PersistantStorage {}
