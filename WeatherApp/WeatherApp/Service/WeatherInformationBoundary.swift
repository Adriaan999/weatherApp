//
//  WeatherInformationBoundary.swift
//  WeatherApp
//
//  Created by Adriaan van Schalkwyk on 2022/01/13.
//

import Foundation

typealias FetchCurrentWeatherSuccess = (WeatherInformationResponseModel?) -> Void
typealias FetchCityWeatherSuccess = (WeatherInformationResponseModel?) -> Void
typealias FetchForcastedWeatherSuccess = (WeatherForcastInformationResponseModel?) -> Void
typealias FetchForcastedCityWeatherSuccess = (WeatherForcastInformationResponseModel?) -> Void

typealias FetchWeatherDataFailure = (Error) -> Void

protocol WeatherInformationBoundary {
    
    func fetchWeather(latitude: Double,
                      longitude: Double,
                      success: @escaping FetchCurrentWeatherSuccess,
                      failure: @escaping FetchWeatherDataFailure)
    
    func fetchWeather(cityName: String,
                      success: @escaping FetchCityWeatherSuccess,
                      failure: @escaping FetchWeatherDataFailure)
    
    func fetchForcastedWeather(latitude: Double,
                               longitude: Double,
                               success: @escaping FetchForcastedWeatherSuccess,
                               failure: @escaping FetchWeatherDataFailure)
    
    func fetchForcastedWeather(cityName: String,
                               success: @escaping FetchForcastedCityWeatherSuccess,
                               failure: @escaping FetchWeatherDataFailure)
}
