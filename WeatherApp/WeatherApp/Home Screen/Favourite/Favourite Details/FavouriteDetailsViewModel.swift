//
//  FavouriteDetailsViewModel.swift
//  WeatherApp
//
//  Created by Adriaan van Schalkwyk on 2022/01/17.
//

import Foundation

struct FavouriteDetailsViewModel {
    
    var weatherData: WeatherInformationResponseModel
    
    
    var currentTemp: String {
        return String(format: "%.0f", weatherData.main.temp)
    }
    
    var currentCity: String {
        return weatherData.name
    }
    
    var conditionName: String {
        let conditionCode = weatherData.weather[0].conditionCode
        switch conditionCode {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
