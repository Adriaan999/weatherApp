//
//  WeatherInformationInteractor.swift
//  WeatherApp
//
//  Created by Adriaan van Schalkwyk on 2022/01/13.
//

import Foundation

class WeatherInformationInteractor: WeatherInformationBoundary {
    
    private let networkManager = NetworkManager()
    private let weatherURL = ""
    private let forcastedWeatherURL = ""
    
    func fetchWeather(latitude: Double,
                      longitude: Double,
                      success: @escaping FetchCurrentWeatherSuccess,
                      failure: @escaping FetchWeatherDataFailure) {
        
        let url = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"

        networkManager.performRequest(url: url, successBlock: { (data) in
            guard let weatherData: WeatherInformationResponseModel = try? data.decoded() else {
                let errorDescription = "A localized description of an error"
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorDescription])
                failure(error)
                return
            }
            success(weatherData)
        }, failureBlock: { (error) in
            failure(error)
            return
        })
    }
    
    func fetchWeather(cityName: String,
                      success: @escaping FetchCurrentWeatherSuccess,
                      failure: @escaping FetchWeatherDataFailure) {
        
        let url = "\(weatherURL)&q=\(cityName)"

        networkManager.performRequest(url: url, successBlock: { (data) in
            guard let weatherData: WeatherInformationResponseModel = try? data.decoded() else {
                let errorDescription = "A localized description of an error"
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorDescription])
                failure(error)
                return
            }
            success(weatherData)
        }, failureBlock: { (error) in
            failure(error)
            return
        })
        
    }
    
    func fetchForcastedWeather(latitude: Double,
                               longitude: Double,
                               success: @escaping FetchForcastedWeatherSuccess,
                               failure: @escaping FetchWeatherDataFailure) {
        
        let url = "\(forcastedWeatherURL)&lat=\(latitude)&lon=\(longitude)"

        networkManager.performRequest(url: url, successBlock: { (data) in
            guard let weatherData: WeatherForcastInformationResponseModel = try? data.decoded() else {
                let errorDescription = "A localized description of an error"
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorDescription])
                failure(error)
                return
            }
            success(weatherData)
        }, failureBlock: { (error) in
            failure(error)
            return
        })
    }
    
    func fetchForcastedWeather(cityName: String,
                               success: @escaping FetchForcastedCityWeatherSuccess,
                               failure: @escaping FetchWeatherDataFailure) {
        let url = "\(forcastedWeatherURL)&q=\(cityName)"

        networkManager.performRequest(url: url, successBlock: { (data) in
            guard let weatherData: WeatherForcastInformationResponseModel = try? data.decoded() else {
                let errorDescription = "A localized description of an error"
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorDescription])
                failure(error)
                return
            }
            success(weatherData)
        }, failureBlock: { (error) in
            failure(error)
            return
        })
        
    }
    
    
}
//enum ValidationError: Error {
//    case parsing
//    case decode
//    case etc
//}
