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
    let id: Int
    
    init(id: Int, temp_min: Int, temp_max: Int) {
        self.id = id
        self.temp_min = temp_min
        self.temp_max = temp_max
    }
}
