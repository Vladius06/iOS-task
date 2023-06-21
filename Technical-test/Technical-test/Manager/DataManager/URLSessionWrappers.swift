//
//  URLSessionWrappers.swift
//  Technical-test
//
//  Created by Vladyslav Poznyak on 21.06.2023.
//

import Foundation

protocol URLSessionType {
    func dataTask(with: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskType
}

extension URLSession: URLSessionType {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskType {
        let task: URLSessionDataTask = dataTask(with: request, completionHandler: completionHandler)
        return task
    }
}

protocol URLSessionDataTaskType {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskType {}
