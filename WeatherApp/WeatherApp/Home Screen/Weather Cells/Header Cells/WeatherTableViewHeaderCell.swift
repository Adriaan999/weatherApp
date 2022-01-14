//
//  WeatherTableViewHeaderCell.swift
//  WeatherApp
//
//  Created by Adriaan van Schalkwyk on 2022/01/13.
//

import UIKit

class WeatherTableViewHeaderCell: UITableViewCell {
    
    @IBOutlet private var minTempLabel: UILabel!
    @IBOutlet private var currentTempLabel: UILabel!
    @IBOutlet private var maxTempLabel: UILabel!
    
    func populate(_ backgroundColor: String,
             minTemp: String,
             currentTemp: String,
             maxTemp: String) {
        self.backgroundColor = UIColor(named: backgroundColor)
        self.minTempLabel.text = "\(minTemp)°"
        self.currentTempLabel.text = "\(currentTemp)°"
        self.maxTempLabel.text = "\(maxTemp)°"
    }
}
