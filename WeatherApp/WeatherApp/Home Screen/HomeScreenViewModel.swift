//
//  HomeScreenViewModel.swift
//  WeatherApp
//
//  Created by Adriaan van Schalkwyk on 2022/01/13.
//

import Foundation

fileprivate typealias WeatherDataCompletion = (Error?) -> Void

protocol HomeScreenViewModelDelegate {
    func didUpateWeather()
    func errorHandler()
}

class HomeScreenViewModel {
    
    private var interactor: WeatherInformationBoundary
    private var weatherData: WeatherInformationResponseModel?
    private var delegate: HomeScreenViewModelDelegate?
    private(set) var forcastedWeatherData: WeatherForcastInformationResponseModel?
    
    init(interactor: WeatherInformationBoundary,
         delegate: HomeScreenViewModelDelegate) {
        self.interactor = interactor
        self.delegate = delegate
    }
    
    var minTemp: String {
        return String(format: "%.0f", weatherData?.main.tempMin ?? 0.0)
    }
    
    var currentTemp: String {
        return String(format: "%.0f", weatherData?.main.temp ?? 0.0)
    }
    
    var maxTemp: String {
        return String(format: "%.0f", weatherData?.main.tempMax ?? 0.0)
    }
    
    var currentCity: String {
        return weatherData?.name ?? ""
    }
    
    var currentConditions: String {
        return (weatherData?.weather[0].condition ?? "").uppercased()
    }
    
    func forcastedCondition(_ index: Int) -> String {
        let condition = forcastedWeatherData?.weatherData[index].weather[0].condition.uppercased()
        switch condition {
        case "CLOUDS", "MIST", "FOG":
            return "PartlySunny"
        case "CLEAR":
            return "Clear"
        case "RAIN":
            return "Rain"
        default:
            return "Clear"
        }
    }
    
    func maxForcastedTemp(_ index: Int) -> String {
        return String(format: "%.0f", forcastedWeatherData?.weatherData[index].tempData.tempMax ?? 0.0)
    }
    
    func dayOfTheWeek(_ index: Int) -> (day: String, time: String) {
        let date = forcastedWeatherData?.weatherData[index].date
        let day = Date.from(dateString: date ?? "", withFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "EEEE") ?? ""
        let time = Date.from(dateString: date ?? "", withFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "HH:mm a") ?? ""
        return (day, time)
    }
    
    func background() -> (image: String, colour: String) {
        switch currentConditions {
        case "CLOUDS", "MIST", "FOG":
            return ("forest_cloudy", "Cloudy")
        case "CLEAR":
            return ("forest_sunny", "Sunny")
        case "RAIN":
            return ("forest_rainy", "Rainy")
        default:
            return ("forest_sunny", "Sunny")
        }
    }
    
    func fetchWeatherInformation(latitude: Double, longitude: Double) {
        let dispatchGroup = DispatchGroup()
        var errorMessage: String?
        
        dispatchGroup.enter()
        fetchWeatherData(latitude: latitude, longitude: longitude) { error in
            if let error = error {
                errorMessage = error.localizedDescription
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchForcstWeatherData(latitude: latitude, longitude: longitude) { error in
            if let error = error {
                errorMessage = error.localizedDescription
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            if errorMessage != nil {
                self.delegate?.errorHandler()
            } else {
                self.delegate?.didUpateWeather()
            }
        }
    }
    
    func fetchWeatherInformation(cityName: String) {
        let dispatchGroup = DispatchGroup()
        var errorMessage: String?
        
        dispatchGroup.enter()
        fetchWeatherData(cityName: cityName) { error in
            if let error = error {
                errorMessage = error.localizedDescription
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchForcstWeatherData(cityName: cityName) { error in
            if let error = error {
                errorMessage = error.localizedDescription
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            if errorMessage != nil {
                self.delegate?.errorHandler()
            } else {
                self.delegate?.didUpateWeather()
            }
        }
    }

    private func fetchForcstWeatherData(latitude: Double, longitude: Double, completion: @escaping WeatherDataCompletion) {
        interactor.fetchForcastedWeather(latitude: latitude, longitude: longitude) { [weak self] (response) in
            self?.forcastedWeatherData = response
            completion(nil)
        } failure: { (error) in
            completion(error)
        }
    }
    
    private func fetchWeatherData(cityName: String, completion: @escaping WeatherDataCompletion) {
        interactor.fetchWeather(cityName: cityName) { [weak self] (response) in
            self?.weatherData = response
            completion(nil)
        } failure: { (error) in
            completion(error)
        }
    }
    
    private func fetchForcstWeatherData(cityName: String, completion: @escaping WeatherDataCompletion) {
        interactor.fetchForcastedWeather(cityName: cityName) { [weak self] (response) in
            self?.forcastedWeatherData = response
            completion(nil)
        } failure: { (error) in
            completion(error)
        }
    }
    
    private func fetchWeatherData(latitude: Double, longitude: Double, completion: @escaping WeatherDataCompletion) {
        interactor.fetchWeather(latitude: latitude, longitude: longitude) { [weak self] (response) in
            self?.weatherData = response
            completion(nil)
        } failure: { (error) in
            completion(error)
        }
    }
}
