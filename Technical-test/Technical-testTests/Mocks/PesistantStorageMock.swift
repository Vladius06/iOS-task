//
//  PesistantStorageMock.swift
//  Technical-testTests
//
//  Created by Vladyslav Poznyak on 20.06.2023.
//

import Foundation
@testable import Technical_test

class PersistantStorageMock: PersistantStorage {
    var store: [String: Any] = [:]
    
    func value(forKey key: String) -> Any? {
        store[key]
    }
    
    func set(_ value: Any?, forKey key: String) {
        store[key] = value
    }
}
