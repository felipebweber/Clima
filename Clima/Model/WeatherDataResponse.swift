//
//  WeatherData.swift
//  Clima
//
//  Created by Felipe Weber on 04/03/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import Foundation

class WeatherDataResponse: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

extension WeatherDataResponse {
    struct Main: Codable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Int
        let humidity: Int
    }

    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
}
