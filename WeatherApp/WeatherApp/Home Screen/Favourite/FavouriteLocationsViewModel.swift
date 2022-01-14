//
//  FavouriteLocationsViewModel.swift
//  WeatherApp
//
//  Created by Adriaan van Schalkwyk on 2022/01/14.
//

import Foundation

import CoreData

protocol CoreDataManagerDelegate {
    func didUpdateData()
    func didfetchData(ID: Int, cityName: String)
    func errorHandler()
}

class FavouriteLocationsViewModel {
    
    private var delegate: CoreDataManagerDelegate
    private var context: NSManagedObjectContext
    private var interactor: WeatherInformationBoundary
    private var weatherData: WeatherInformationResponseModel?
    private(set) var dataList = [Favourite]()

    init(delegate: CoreDataManagerDelegate,
         context: NSManagedObjectContext,
         interactor: WeatherInformationBoundary) {
        self.delegate = delegate
        self.context = context
        self.interactor = interactor
    }

    func saveData(_ ID: Int, cityName: String) {
        let newItem = Favourite(context: self.context)
        newItem.id = Int16(ID)
        newItem.name = cityName
        do {
            try context.save()
            delegate.didUpdateData()
        } catch {
            print("Error saving item \(error)")
        }
    }
    
    func deleteData(with ID: String, type: String) {
        let request : NSFetchRequest<Favourite> = Favourite.fetchRequest()
        let predicate = NSPredicate(format: "id = %@", ID, type)
        request.predicate = predicate

        do {
            let test = try context.fetch(request)
            if let objectToDelete = test.first {
                context.delete(objectToDelete)
                do {
                    try context.save()
                } catch {
                    print("Error saving item \(error)")
                }
            }
            delegate.didUpdateData()
        } catch {
            print("Error deleting item \(error)")
        }
    }

    func loadData() {
        let request : NSFetchRequest<Favourite> = Favourite.fetchRequest()
        do {
            dataList = try context.fetch(request)
            delegate.didUpdateData()
        } catch {
            print("Error loading fact \(error)")
        }
    }
    
    func fetchWeatherData(cityName: String) {
        interactor.fetchWeather(cityName: cityName) { [weak self] (response) in
            if let id = response?.weather[0].id,
               let name = response?.name {
                self?.delegate.didfetchData(ID: id, cityName: name)
            } else {
                self?.delegate.errorHandler()
            }
        } failure: { [weak self] (error) in
            self?.delegate.errorHandler()
        }
    }
}
