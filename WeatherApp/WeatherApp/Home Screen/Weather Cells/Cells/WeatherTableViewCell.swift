//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Adriaan van Schalkwyk on 2022/01/13.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet private var dayOfTheWeekLabel: UILabel!
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var conditionImageView: UIImageView!
    @IBOutlet private var temperatureLabel: UILabel!
    
    
    func populate(_ backgroundColor: String,
                  dayOfTheWeek: String,
                  timeOfTheDay: String,
                  condition: String,
                  temperature: String) {
        self.backgroundColor = UIColor(named: backgroundColor)
        dayOfTheWeekLabel.text = dayOfTheWeek
        timeLabel.text = timeOfTheDay
        conditionImageView.image = UIImage(named: condition) 
        temperatureLabel.text = "\(temperature)°"
    }
}
