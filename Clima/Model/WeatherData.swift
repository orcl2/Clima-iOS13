//
//  WeatherData.swift
//  Clima
//
//  Created by William Daniel da Silva Kuhs on 26/02/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreImage

struct WeatherData: Codable {
    let name: String
    let coord: Coord
    let main: Main
    let weather: [Weather]
}

struct Coord: Codable {
    let lon: Float
    let lat: Float
}

struct Main: Codable {
    let temp: Double
    let pressure: Double
    let humidity: Double
    let tempMin: Double
    let tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case temp
        case pressure
        case humidity
    }
}

struct Weather: Codable {
    let id: Int
    let description: String
}

