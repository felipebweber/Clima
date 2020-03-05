//
//  WeatherData.swift
//  Clima
//
//  Created by Felipe Weber on 04/03/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}
