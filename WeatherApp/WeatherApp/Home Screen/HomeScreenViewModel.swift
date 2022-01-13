//
//  HomeScreenViewModel.swift
//  WeatherApp
//
//  Created by Adriaan van Schalkwyk on 2022/01/13.
//

import Foundation

class HomeScreenViewModel {
    
    private var interactor: WeatherInformationBoundary
    private var weatherData: WeatherInformationResponseModel?
    
    init(interactor: WeatherInformationBoundary) {
        self.interactor = interactor
    }
    
    func fetchWeatherData() {
        interactor.fetchWeather(cityName: "Cape Town") { (response) in
            self.weatherData = response
        } failure: { (error) in
            print(error.localizedDescription)
        }

    }
}
