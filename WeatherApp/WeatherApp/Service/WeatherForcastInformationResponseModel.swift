//
//  WeatherForcastInformationResponseModel.swift
//  WeatherApp
//
//  Created by Adriaan van Schalkwyk on 2022/01/14.
//

import Foundation

struct WeatherForcastInformationResponseModel: Decodable {
    let weatherData: [List]
    
    enum CodingKeys: String, CodingKey {
        case weatherData = "list"
    }
}

struct List: Decodable {
    let weather: [Weather]
    let tempData: Main
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case weather
        case tempData = "main"
        case date = "dt_txt"
    }
}
