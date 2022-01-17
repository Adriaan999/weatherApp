//
//  FavouriteTableViewCell.swift
//  WeatherApp
//
//  Created by Adriaan van Schalkwyk on 2022/01/14.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {
    
    @IBOutlet var cityNameLabel: UILabel!
    
    func populate(cityName: String) {
        self.cityNameLabel.text = cityName
    }
}
