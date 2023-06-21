//
//  DataManagerTests.swift
//  Technical-testTests
//
//  Created by Vladyslav Poznyak on 21.06.2023.
//

import XCTest
@testable import Technical_test

final class DataManagerTests: XCTestCase {
    let sut = DataManager()
    
    let mockPath = "https://example.com"
    let mockSession = URLSessionMock()
    
    override func setUpWithError() throws {
        sut.use(mockSession)
        sut.use(mockPath)
    }

    func testSuccessfullFetch() {
        //given
        let json = """
[{"news":"1","paidPrices":"0","estimates":"0","orderbook":"0","analyseIt":"0","description":"0","exchange":"SIX Indices","close":"11,306.64","lastTime":"173052","isin":"CH0009980894","exchangeId":"-9","high":"11,315.73","low":"11,215.91","volume":null,"bid":"-","ask":"-","typeId":"4","priceAlertable":"1","newsAlertable":"1","delayed":"Delayed time","lastChange":"-90.73","lastChangePercent":"-0.8024","lastDate":"20230620","tradable":"0","askSize":null,"bidSize":null,"low52":"10,010.78","open":"11,271.57","high52":"11,616.37","industryName":null,"sectorName":null,"estimatedPrice":"","partOfSQX":"0","stopTrading":"","readableLastChangePercent":"-0.80 %","readableLastTimeOrDate":"6/20/23","variationColor":"red","sharable":"1","last":"11,215.91","symbol":"SMI","currency":"CHF","name":"SMI® PR","key":"CH0009980894_M9_CHF"},{"news":"1","paidPrices":"1","estimates":"1","orderbook":"0","analyseIt":"0","description":"1","exchange":"SIX","close":"557.80","lastTime":"173052","isin":"CH0008742519","exchangeId":"4","high":"-","low":"-","volume":null,"bid":"At market","ask":"560.00","typeId":"0","priceAlertable":"1","newsAlertable":"1","delayed":"Delayed time","lastChange":null,"lastChangePercent":null,"lastDate":"20230620","tradable":"2","askSize":"100.00","bidSize":"159.00","low52":"443.40","open":"-","high52":"619.40","industryName":null,"sectorName":null,"estimatedPrice":"Estim. 563.00","partOfSQX":"0","stopTrading":"Estim. 563.00","readableLastChangePercent":null,"readableLastTimeOrDate":"6/20/23","variationColor":null,"sharable":"1","last":"557.80","symbol":"SCMN","currency":"CHF","name":"SWISSCOM N","key":"CH0008742519_4_CHF"}]
""".data(using: .utf8)
        
        let url = URL(string: mockPath)!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockSession.results[URLRequest(url: url)] = (json, response, nil)
        let completionCalled = expectation(description: "completion handler called")
        
        //when
        sut.fetchQuotes { result in
            if case let .success(quotes) = result {
                XCTAssertEqual(quotes[0].symbol, "SMI")
                XCTAssertEqual(quotes[0].name, "SMI® PR")
                XCTAssertEqual(quotes[0].readableLastChangePercent, "-0.80 %")
                XCTAssertEqual(quotes[0].currency, "CHF")
                XCTAssertEqual(quotes[0].last, "11,215.91")
                XCTAssertEqual(quotes[0].variationColor, .red)
                
                XCTAssertEqual(quotes[1].symbol, "SCMN")
                XCTAssertEqual(quotes[1].name, "SWISSCOM N")
                XCTAssertEqual(quotes[1].readableLastChangePercent, nil)
                XCTAssertEqual(quotes[1].currency, "CHF")
                XCTAssertEqual(quotes[1].last, "557.80")
                XCTAssertEqual(quotes[1].variationColor, nil)
            } else {
                XCTFail("unexpected result \(result)")
            }
            completionCalled.fulfill()
        }
        
        //then
        wait(for: [completionCalled], timeout: 0.1)
    }
    
    func testFetchWithInvalidPath() {
        //given
        sut.use("this is not a valid path")
        let completionCalled = expectation(description: "completion handler called")
        //when
        sut.fetchQuotes { result in
            if case .failure(DataManager.FetchError.failedToConstructURL) = result {
            } else {
                XCTFail("unexpected result \(result)")
            }
            completionCalled.fulfill()
        }
        //then
        wait(for: [completionCalled], timeout: 0.1)
    }

    func testFetchFailed() {
        //given
        enum TestError: Error {
            case mockError
        }
        let url = URL(string: mockPath)!
        mockSession.results[URLRequest(url: url)] = (nil, nil, TestError.mockError)
        let completionCalled = expectation(description: "completion handler called")
        
        //when
        sut.fetchQuotes { result in
            if case let .failure(DataManager.FetchError.failedToExecuteRequest(error as TestError)) = result {
                XCTAssertEqual(error, .mockError)
            } else {
                XCTFail("unexpected result \(result)")
            }
            completionCalled.fulfill()
        }
        
        //then
        wait(for: [completionCalled], timeout: 0.1)
    }
    
    func testFetchReturnedWrongResponse() {
        //given
        let url = URL(string: mockPath)!
        let response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)
        mockSession.results[URLRequest(url: url)] = (nil, response, nil)
        let completionCalled = expectation(description: "completion handler called")
        
        //when
        sut.fetchQuotes { result in
            if case let .failure(DataManager.FetchError.unexpectedResponse(aResponse)) = result {
                XCTAssertEqual(aResponse, response)
            } else {
                XCTFail("unexpected result \(result)")
            }
            completionCalled.fulfill()
        }
        
        //then
        wait(for: [completionCalled], timeout: 0.1)
    }
    
    func testFetchReturnedNoData() {
        //given
        let url = URL(string: mockPath)!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockSession.results[URLRequest(url: url)] = (nil, response, nil)
        let completionCalled = expectation(description: "completion handler called")
        
        //when
        sut.fetchQuotes { result in
            if case .failure(DataManager.FetchError.noDataReceived) = result {
            } else {
                XCTFail("unexpected result \(result)")
            }
            completionCalled.fulfill()
        }
        
        //then
        wait(for: [completionCalled], timeout: 0.1)
    }
    
    func testFetchReturnedCorruptedData() {
        let json = """
This is not a json 😈
""".data(using: .utf8)
        
        let url = URL(string: mockPath)!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockSession.results[URLRequest(url: url)] = (json, response, nil)
        let completionCalled = expectation(description: "completion handler called")
        
        //when
        sut.fetchQuotes { result in
            if case .failure(DataManager.FetchError.failedToDecodeData(DecodingError.dataCorrupted)) = result {
            } else {
                XCTFail("unexpected result \(result)")
            }
            completionCalled.fulfill()
        }
        
        //then
        wait(for: [completionCalled], timeout: 0.1)
    }
}
