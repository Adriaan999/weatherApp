//
//  FavouriteDetailsViewController.swift
//  WeatherApp
//
//  Created by Adriaan van Schalkwyk on 2022/01/17.
//

import UIKit

class FavouriteDetailsViewController: UIViewController {
    
    @IBOutlet private var conditionImageView: UIImageView!
    @IBOutlet private var currentTempLabel: UILabel!
    @IBOutlet private var cityNameLabel: UILabel!
    
    var weatherData: WeatherInformationResponseModel!
    private lazy var viewModel = FavouriteDetailsViewModel(weatherData: weatherData)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.conditionImageView.image = UIImage(systemName: viewModel.conditionName)
        self.currentTempLabel.text = "\(viewModel.currentTemp)°"
        self.cityNameLabel.text = viewModel.currentCity
    }
}
