//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Adriaan van Schalkwyk on 2022/01/13.
//

import Foundation


enum NetworkError: LocalizedError, Equatable {
    case responseModelParsingError
    case invalidRequestURLStringError
    case failedRequestError
    case networkError
}

class NetworkManager: NetworkManagerBoundary {
    
    private var dataTask: URLSessionDataTask?
    private var networkURLSession: URLSession!
    
    func performRequest(url: String,
                        successBlock: @escaping PerformRequestSuccess,
                        failureBlock: @escaping PerformRequestFailure) {
        if let url = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
            networkURLSession = URLSession(configuration: .default)
            dataTask = networkURLSession.dataTask(with: url) { [weak self] (data, response, error) in
                defer { self?.dataTask = nil }
                if error != nil {
                    failureBlock(.failedRequestError)
                    return
                }
                guard let responseData = data else {
                    failureBlock(.responseModelParsingError)
                    return
                }
                successBlock(responseData)
                return
            }
            dataTask?.resume()
        } else {
            failureBlock(.invalidRequestURLStringError)
            return
        }
    }
}
