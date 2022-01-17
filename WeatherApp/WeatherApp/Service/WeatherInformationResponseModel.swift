//
//  WeatherInformationResponseModel.swift
//  WeatherApp
//
//  Created by Adriaan van Schalkwyk on 2022/01/13.
//

import Foundation

struct WeatherInformationResponseModel: Decodable {
    let name: String
    let id: Int
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
    let tempMin: Double
    let tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct Weather: Decodable {
    let condition: String
    let conditionCode: Int
    
    enum CodingKeys: String, CodingKey {
        case condition = "main"
        case conditionCode = "id"
    }
}
