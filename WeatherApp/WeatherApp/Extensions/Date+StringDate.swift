//
//  Date+StringDate.swift
//  WeatherApp
//
//  Created by Adriaan van Schalkwyk on 2022/01/14.
//

import Foundation

extension Date {
    static func from(dateString: String, withFormat: String, toFormat: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = withFormat
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = toFormat
            return outputFormatter.string(from: date)
        }
        return nil
    }
}
