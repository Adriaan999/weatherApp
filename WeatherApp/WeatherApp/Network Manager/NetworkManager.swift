//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Adriaan van Schalkwyk on 2022/01/13.
//

import Foundation

class NetworkManager: NetworkManagerBoundary {
    
    private var dataTask: URLSessionDataTask?
    private var networkURLSession: URLSession!

    func performRequest(url: String,
                        successBlock: @escaping PerformRequestSuccess,
                        failureBlock: @escaping PerformRequestFailure) {
        if let url = URL(string: url) {
            networkURLSession = URLSession(configuration: .default)
            dataTask = networkURLSession.dataTask(with: url) { [weak self] (data, response, error) in
            defer { self?.dataTask = nil }
                if let error = error {
                    return failureBlock(error)
                }
                guard let responseData = data else {
                    return failureBlock(error!) }
                return successBlock(responseData)
            }
            dataTask?.resume()
        }
    }
}
