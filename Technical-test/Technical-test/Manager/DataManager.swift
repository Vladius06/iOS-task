//
//  DataManager.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 29.04.21.
//

import Foundation


class DataManager {
    
    private static let path = "https://www.swissquote.ch/mobile/iphone/Quote.action?formattedList&formatNumbers=true&listType=SMI&addServices=true&updateCounter=true&&s=smi&s=$smi&lastTime=0&&api=2&framework=6.1.1&format=json&locale=en&mobile=iphone&language=en&version=80200.0&formatNumbers=true&mid=5862297638228606086&wl=sq"
    
    enum FetchError: Error {
        case failedToConstructURL
        case failedToExecuteRequest(Error)
        case unexpectedResponse(URLResponse?)
        case noDataReceived
        case failedToDecodeData(Error)
    }
    
    func fetchQuotes(completionHandler: @escaping (Result<[Quote], Error>) -> Void) {
        guard let url = URL(string: DataManager.path) else {
            completionHandler(.failure(FetchError.failedToConstructURL))
            return
        }
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completionHandler(.failure(FetchError.failedToExecuteRequest(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                completionHandler(.failure(FetchError.unexpectedResponse(response)))
                return
            }
            
            guard let data else {
                completionHandler(.failure(FetchError.noDataReceived))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let quotes = try decoder.decode([Quote].self, from: data)
                completionHandler(.success(quotes))
            } catch {
                completionHandler(.failure(FetchError.failedToDecodeData(error)))
            }
        }
        task.resume()
    }
    
}
