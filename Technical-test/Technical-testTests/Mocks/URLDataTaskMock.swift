//
//  URLDataTaskMock.swift
//  Technical-testTests
//
//  Created by Vladyslav Poznyak on 21.06.2023.
//

import Foundation
@testable import Technical_test

class URLDataTaskMock: URLSessionDataTaskType {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    var completion: (Data?, URLResponse?, Error?) -> Void
    
    var isResumed = false
    
    init(data: Data? = nil,
         response: URLResponse? = nil,
         error: Error? = nil,
         completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.data = data
        self.response = response
        self.error = error
        self.completion = completion
    }
    
    func resume() {
        isResumed = true
        completion(data, response, error)
    }
}
