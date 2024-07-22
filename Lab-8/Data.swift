//
//  Data.swift
//  Lab-8
//
//  Created by user252704 on 7/22/24.
//

import Foundation

struct WeatherData: Codable {
    let weather: [WeatherElement]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let dt: Int?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
}

struct Main: Codable {
    let temp: Double?
    let humidity: Int?
}

struct WeatherElement: Codable {
    let id: Int?
    let main, description, icon: String?
}

struct Wind: Codable {
    let speed: Double?
}
