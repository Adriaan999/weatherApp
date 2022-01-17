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
    @IBOutlet private var searchTextField: UITextField!
    
    private lazy var locationManager = CLLocationManager()
    private lazy var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    private lazy var viewModel = HomeScreenViewModel(interactor: WeatherInformationInteractor(),
                                                     delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLoadindAnimation()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        
        searchTextField.delegate = self
        
        setupTableViewCell()
    }
    
    @IBAction private func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        startLoadindAnimation()
    }
    
    private func setupTableViewCell() {
        self.weatherTableView.register(UINib(nibName: "WeatherTableViewCell", bundle: Bundle.main),
                                       forCellReuseIdentifier: "WeatherTableViewCell")
        
        self.weatherTableView.register(UINib(nibName: "WeatherTableViewHeaderCell", bundle: Bundle.main),
                                       forCellReuseIdentifier: "WeatherTableViewHeaderCell")
    }
    
    private func startLoadindAnimation() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
}

extension HomeScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.forcastedWeatherData?.weatherData.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        let dayOfTheWeek = viewModel.dayOfTheWeek(indexPath.row)
        cell.populate(viewModel.background().colour,
                      dayOfTheWeek: dayOfTheWeek.day,
                      timeOfTheDay: dayOfTheWeek.time,
                      condition: viewModel.forcastedCondition(indexPath.row),
                      temperature: viewModel.maxForcastedTemp(indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewHeaderCell") as! WeatherTableViewHeaderCell
        headerCell.populate(viewModel.background().colour,
                            minTemp: viewModel.minTemp,
                            currentTemp: viewModel.currentTemp,
                            maxTemp: viewModel.maxTemp)
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}


extension HomeScreenViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            viewModel.fetchWeatherInformation(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension HomeScreenViewController: HomeScreenViewModelDelegate {
    
    func didUpateWeather() {
        DispatchQueue.main.async {
            self.currentTempLabel.text = "\(self.viewModel.currentTemp)°"
            self.cityNameLabel.text = self.viewModel.currentCity
            self.conditionsLabel.text = self.viewModel.currentConditions
            self.backGroundImage.image = UIImage(named: self.viewModel.background().image)
            self.weatherTableView.backgroundColor = UIColor(named: self.viewModel.background().colour)
            self.weatherTableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    func errorHandler() {
        self.activityIndicator.stopAnimating()
        let title = "Error with request"
        let message = "Your request could not be processed at this time."
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            alert.view.accessibilityIdentifier = "errorAlertDialog"
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension HomeScreenViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            viewModel.fetchWeatherInformation(cityName: city)
        }
        searchTextField.text = ""
    }
}

