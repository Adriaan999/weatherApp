//
//  HomeScreenViewController.swift
//  WeatherApp
//
//  Created by Adriaan van Schalkwyk on 2022/01/13.
//

import UIKit
import CoreLocation

class HomeScreenViewController: UIViewController {
 
    @IBOutlet private var currentTempLabel: UILabel!
    @IBOutlet private var cityNameLabel: UILabel!
    @IBOutlet private var conditionsLabel: UILabel!
    @IBOutlet private var backGroundImage: UIImageView!
    @IBOutlet private var weatherTableView: UITableView!
    
    let locationManager = CLLocationManager()
    
    private lazy var viewModel = HomeScreenViewModel(interactor: WeatherInformationInteractor(),
                                                     delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        
        setupTableViewCell()
    }
    
    private func setupTableViewCell() {
        self.weatherTableView.register(UINib(nibName: "WeatherTableViewCell", bundle: Bundle.main),
                                forCellReuseIdentifier: "WeatherTableViewCell")
        
        self.weatherTableView.register(UINib(nibName: "WeatherTableViewHeaderCell", bundle: Bundle.main),
                                forCellReuseIdentifier: "WeatherTableViewHeaderCell")
    }
    
}

extension HomeScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        cell.backgroundColor = UIColor(named: "Cloudy")
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewHeaderCell") as! WeatherTableViewHeaderCell
        headerCell.backgroundColor = UIColor(named: "Cloudy")
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}


extension HomeScreenViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            viewModel.fetchWeatherData(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension HomeScreenViewController: HomeScreenViewModelDelegate {
    
    func didUpateWeather() {
        DispatchQueue.main.async {
            self.currentTempLabel.text = self.viewModel.currentTemp
            self.cityNameLabel.text = self.viewModel.currentCity
            self.conditionsLabel.text = self.viewModel.currentConditions
            self.backGroundImage.image = UIImage(named: self.viewModel.backgroundImage)
            self.weatherTableView.backgroundColor = UIColor(named: "Cloudy")
        }
    }
}
