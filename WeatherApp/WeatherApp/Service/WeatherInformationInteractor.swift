//
//  WeatherInformationInteractor.swift
//  WeatherApp
//
//  Created by Adriaan van Schalkwyk on 2022/01/13.
//

import Foundation

class WeatherInformationInteractor: WeatherInformationBoundary {
    
    private let networkManager = NetworkManager()
    var shouldMockRequest: Bool = false
    private let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=&units=metric"
    private let forcastedWeatherURL = "https://api.openweathermap.org/data/2.5/forecast?&appid=&units=metric"
    
    func fetchWeather(latitude: Double,
                      longitude: Double,
                      success: @escaping FetchCurrentWeatherSuccess,
                      failure: @escaping FetchWeatherDataFailure) {
        
        let url = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        
        networkManager.performRequest(url: url, successBlock: { (data) in
            guard let weatherData: WeatherInformationResponseModel = try? data.decoded() else {
                failure(.responseModelParsingError)
                return
            }
            success(weatherData)
        }, failureBlock: { (error) in
            failure(.failedRequestError)
            return
        })
    }
    
    func fetchWeather(cityName: String,
                      success: @escaping FetchCurrentWeatherSuccess,
                      failure: @escaping FetchWeatherDataFailure) {
        
        let url = "\(weatherURL)&q=\(cityName)"
        
        networkManager.performRequest(url: url, successBlock: { (data) in
            guard let weatherData: WeatherInformationResponseModel = try? data.decoded() else {
                failure(.responseModelParsingError)
                return
            }
            success(weatherData)
        }, failureBlock: { (error) in
            failure(.failedRequestError)
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
                failure(.responseModelParsingError)
                return
            }
            success(weatherData)
        }, failureBlock: { (error) in
            failure(.failedRequestError)
            return
        })
    }
    
    func fetchForcastedWeather(cityName: String,
                               success: @escaping FetchForcastedCityWeatherSuccess,
                               failure: @escaping FetchWeatherDataFailure) {
        let url = "\(forcastedWeatherURL)&q=\(cityName)"
        
        networkManager.performRequest(url: url, successBlock: { (data) in
            guard let weatherData: WeatherForcastInformationResponseModel = try? data.decoded() else {
                failure(.responseModelParsingError)
                return
            }
            success(weatherData)
        }, failureBlock: { (error) in
            failure(.failedRequestError)
            return
        })
    }
}
