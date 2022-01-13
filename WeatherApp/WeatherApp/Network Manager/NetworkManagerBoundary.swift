//
//  NetworkManagerBoundary.swift
//  WeatherApp
//
//  Created by Adriaan van Schalkwyk on 2022/01/13.
//

import Foundation

typealias PerformRequestSuccess = (Data) -> Void
typealias PerformRequestFailure = (Error) -> Void

protocol NetworkManagerBoundary {
    func performRequest(url: String,
                        successBlock: @escaping PerformRequestSuccess,
                        failureBlock: @escaping PerformRequestFailure)
}
