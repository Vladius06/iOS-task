//
//  URLSessionMock.swift
//  Technical-testTests
//
//  Created by Vladyslav Poznyak on 21.06.2023.
//

import Foundation
@testable import Technical_test

class URLSessionMock: URLSessionType {
    var defaultResult: (Data?, URLResponse?, Error?) = (nil, nil, nil)
    var results: [URLRequest: (Data?, URLResponse?, Error?)] = [:]
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskType {
        let (data, response, error) = results[request] ?? defaultResult
        return URLDataTaskMock(data: data, response: response, error: error, completion: completionHandler)
    }
}
