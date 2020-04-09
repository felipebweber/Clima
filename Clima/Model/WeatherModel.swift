//
//  WeatherModel.swift
//  Clima
//
//  Created by Felipe Weber on 04/03/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

// https://openweathermap.org/weather-conditions

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    var temperatureString: String{
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String{
        switch conditionId {
        case 200...232:
            return "could.bolt"
        case 300...301:
            return "clod.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
}
