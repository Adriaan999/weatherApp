//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Adriaan van Schalkwyk on 2022/01/13.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet private var dayOfTheWeekLabel: UILabel!
    @IBOutlet private var conditionImageView: UIImageView!
    @IBOutlet private var temperatureLabel: UILabel!
    
    
    func populate(_ dayOfTheWeek: String,
             condition: UIImage,
             temperature: String) {
        dayOfTheWeekLabel.text = dayOfTheWeek
        conditionImageView.image = condition
        temperatureLabel.text = temperature
    }
}
