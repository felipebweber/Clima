//
//  WeatherModel.swift
//  Clima
//
//  Created by Felipe Weber on 04/03/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

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
        case 500...521:
            return "cloud.rain"
        case 600...602:
            return "701...781"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max" //Errado
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
}
