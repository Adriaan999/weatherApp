//
//  MockNetworkManager.swift
//  WeatherAppTests
//
//  Created by Adriaan van Schalkwyk on 2022/01/17.
//

import Foundation


class MockNetworkManager: NetworkManagerBoundary {
    
    var shouldFailRequest: Bool = false
    var resource: String = ""
    
    func performRequest(url: String,
                        successBlock: @escaping PerformRequestSuccess,
                        failureBlock: @escaping PerformRequestFailure) {
        let bundle = Bundle(for: type(of: self))
        guard let fileUrl = bundle.url(forResource: resource, withExtension: "json") else {
            failureBlock(NetworkError.invalidRequestURLStringError)
            return
        }
        do {
            if shouldFailRequest {
                throw NetworkError.failedRequestError
            }
            let data = try Data(contentsOf: fileUrl)
            successBlock(data)
        } catch {
            failureBlock(NetworkError.failedRequestError)
        }
    }
}
