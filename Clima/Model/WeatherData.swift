//
//  WeatherData.swift
//  Clima
//
//  Created by William Daniel da Silva Kuhs on 26/02/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreImage

struct WeatherData: Decodable {
    let name: String
    let coord: Coord
    let main: Main
    let weather: [Weather]
}

struct Coord: Decodable {
    let lon: Float
    let lat: Float
}

struct Main: Decodable {
    let temp: Float
    let pressure: Float
    let humidity: Float
    let tempMin: Float
    let tempMax: Float
    
    enum CodingKeys: String, CodingKey {
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case temp
        case pressure
        case humidity
    }
}

struct Weather: Decodable {
    let id: Int
    let description: String
}

