//
//  WeatherModel.swift
//  Clima
//
//  Created by William Daniel da Silva Kuhs on 27/02/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    var temperatureString: String {
        String(format: "%.1f", temperature)
    }
    
    var conditionName: String {
        switch(conditionId) {
        case 200...299:
            return "cloud.bolt.rain"
        case 300...399:
            return "cloud.rain"
        case 500...599:
            return "cloud.heavyrain"
        case 600...699:
            return "cloud.snow"
        case 700...799:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        default:
            return "globe"
        }
    }
}
