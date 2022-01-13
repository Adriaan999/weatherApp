//
//  HomeScreenViewModel.swift
//  WeatherApp
//
//  Created by Adriaan van Schalkwyk on 2022/01/13.
//

import Foundation

protocol HomeScreenViewModelDelegate {
    func didUpateWeather()
}

class HomeScreenViewModel {
    
    private var interactor: WeatherInformationBoundary
    private var weatherData: WeatherInformationResponseModel?
    private var delegate: HomeScreenViewModelDelegate?
    
    init(interactor: WeatherInformationBoundary,
         delegate: HomeScreenViewModelDelegate) {
        self.interactor = interactor
        self.delegate = delegate
    }
    
    var currentTemp: String {
        return String(format: "%.0f", weatherData?.main.temp ?? 0.0)
    }
    
    var currentCity: String {
        return weatherData?.name ?? ""
    }
    
    var currentConditions: String {
        return (weatherData?.weather[0].condition ?? "").uppercased()
    }
    
    var backgroundImage: String {
        switch currentConditions {
        case "CLOUDS", "MIST":
            return "forest_cloudy"
        case "CLEAR":
            return "forest_sunny"
        case "RAIN":
            return "forest_rainy"
        default:
            return "forest_sunny"
        }
    }
    
    func fetchWeatherData() {
        interactor.fetchWeather(cityName: "Cape Town") { (response) in
            self.weatherData = response
        } failure: { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func fetchWeatherData(latitude: Double, longitude: Double) {
        interactor.fetchWeather(latitude: latitude, longitude: longitude) { [weak self] (response) in
            self?.weatherData = response
            self?.delegate?.didUpateWeather()
        } failure: { (error) in
            print(error.localizedDescription)
        }
        
    }
}
