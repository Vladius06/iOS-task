//
//  FavouritesManagerTests.swift
//  Technical-testTests
//
//  Created by Vladyslav Poznyak on 20.06.2023.
//

import XCTest
@testable import Technical_test

final class FavouritesManagerTests: XCTestCase {
    let sut = FavouritesManager.self
    let mockStore = PersistantStorageMock()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut.useStorage(mockStore)
    }

    func testSymbolAddedToFavourites() {
        //when
        sut.toggleFavourite("SMI")
        //then
        XCTAssertEqual(sut.favouriteSymbols, ["SMI"])
    }

    func testSymbolRemovedFromFavourites() {
        //given
        sut.toggleFavourite("SMI")
        //when
        sut.toggleFavourite("SMI")
        //then
        XCTAssertEqual(sut.favouriteSymbols, [])
    }
    
    func testNotifiedAboutChanges() {
        //given
        let notified = XCTNSNotificationExpectation(name: sut.updateNotificationName)
        //when
        sut.toggleFavourite("SMI")
        //then
        wait(for: [notified], timeout: 0.1)
    }
}
