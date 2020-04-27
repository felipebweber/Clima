//
//  WeatherDayDataResponse.swift
//  Clima
//
//  Created by Felipe Weber on 22/04/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import Foundation

class WeatherDayDataResponse: Codable {
    let city: City
    let list: [List]
}

extension WeatherDayDataResponse {
    struct City: Codable {
        let name: String
    }

    struct List: Codable {
        let dt: Int
        let main: Main
        let weather: [Weather]
    }
    
    struct Main: Codable {
        let temp: Double
        let temp_min: Double
        let temp_max: Double
    }
    
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
}
