//
//  FavouriteLocationsViewModel.swift
//  WeatherApp
//
//  Created by Adriaan van Schalkwyk on 2022/01/14.
//

import Foundation

import CoreData

protocol CoreDataManagerDelegate {
    func didLoadWeatherData()
    func didUpdateWeatherData()
    func didfetchWeatherData()
    func errorHandler(message: String)
}

class FavouriteLocationsViewModel {
    
    private var delegate: CoreDataManagerDelegate
    private var context: NSManagedObjectContext
    private var interactor: WeatherInformationBoundary
    private(set) var weatherData: WeatherInformationResponseModel?
    private(set) var dataList = [Favourite]()

    init(delegate: CoreDataManagerDelegate,
         context: NSManagedObjectContext,
         interactor: WeatherInformationBoundary) {
        self.delegate = delegate
        self.context = context
        self.interactor = interactor
    }

    func saveData(_ ID: Int, cityName: String) {
        loadData()
        for savedData in dataList {
            if savedData.id == ID {
                delegate.errorHandler(message: "This locations is already in your favourites list")
                return
            }
        }
        
        let newItem = Favourite(context: self.context)
        newItem.id = Int32(ID)
        newItem.name = cityName
        do {
            try context.save()
            loadData()
            delegate.didUpdateWeatherData()
        } catch {
            delegate.errorHandler(message: "Error saving location: \(error)")
        }
    }
    
    func deleteData(_ ID: Int) {
        let request : NSFetchRequest<Favourite> = Favourite.fetchRequest()
        let predicate = NSPredicate(format: "id = %d", ID)
        request.predicate = predicate

        do {
            let test = try context.fetch(request)
            if let objectToDelete = test.first {
                context.delete(objectToDelete)
                do {
                    try context.save()
                    loadData()
                } catch {
                    delegate.errorHandler(message: "Error deleting location: \(error)")
                }
            }
            delegate.didUpdateWeatherData()
        } catch {
            delegate.errorHandler(message: "Error deleting location: \(error)")
        }
    }

    func loadData() {
        let request : NSFetchRequest<Favourite> = Favourite.fetchRequest()
        do {
            dataList = try context.fetch(request)
            delegate.didLoadWeatherData()
        } catch {
            delegate.errorHandler(message: "Error loading locations: \(error)")
        }
    }
    
    func fetchWeatherData(cityName: String, shouldSave: Bool) {
        interactor.fetchWeather(cityName: cityName) { [weak self] (response) in
            if let id = response?.id,
               let name = response?.name {
                if shouldSave {
                    self?.saveData(id, cityName: name)
                } else {
                    self?.weatherData = response
                    self?.delegate.didfetchWeatherData()
                }
            } else {
                self?.delegate.errorHandler(message: "We regret to inform you that we don't have weather data for this city")
            }
        } failure: { [weak self] (error) in
            self?.delegate.errorHandler(message: "Error fetching weather data: \(error)" )
        }
    }
}
