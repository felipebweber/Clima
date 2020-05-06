//
//  WeatherDayModel.swift
//  Clima
//
//  Created by Felipe Weber on 23/04/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import UIKit

class WeatherDayModel: NSObject {
    let temp_min: Int
    let temp_max: Int
    let temp: Int
    let id: Int
    let cityName: String
    let dt_txt: String
    
    init(id: Int, temp_min: Int, temp_max: Int, temp: Int, cityName: String, dt_txt: String) {
        self.id = id
        self.temp_min = temp_min
        self.temp_max = temp_max
        self.temp = temp
        self.cityName = cityName
        self.dt_txt = dt_txt
    }
    
    var conditionName: String {
        switch id {
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
