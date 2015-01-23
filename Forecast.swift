//
//  Forecast.swift
//  Weather
//
//  Created by student on 20.01.15.
//  Copyright (c) 2015 student. All rights reserved.
//

import UIKit

class Forecast: NSObject {
    
    let dt: NSDate
    let dayOfWeek: DayOfWeek
    
    let tempDay: Double
    let tempNight: Double
    let tempMax: Double
    let tempMin: Double
    
    let pressure: Int
    let humidity: Int
    
    let weatherId: Int
    let weatherMain: String
    let weatherDesc: String
    let weatherIcon: String
    
    init( dt: NSDate,
        dayOfWeek: Int,
        tempDay: Double,
        tempNight: Double,
        tempMax: Double,
        tempMin: Double,
        pressure: Int,
        humidity: Int,
        weatherId: Int,
        weatherMain: String,
        weatherDesc: String,
        weatherIcon: String ) {
            
            self.dt = dt
            self.tempDay = tempDay
            self.tempNight = tempNight
            self.tempMin = tempMin
            self.tempMax = tempMax
            self.pressure = pressure
            self.humidity = humidity
            self.weatherId = weatherId
            self.weatherMain = weatherMain
            self.weatherDesc = weatherDesc
            self.weatherIcon = weatherIcon
            
            switch dayOfWeek {
            case 1:
                self.dayOfWeek = .Sunday
            case 2:
                self.dayOfWeek = .Monday
            case 3:
                self.dayOfWeek = .Tuesday
            case 4:
                self.dayOfWeek = .Wednesday
            case 5:
                self.dayOfWeek = .Thursday
            case 6:
                self.dayOfWeek = .Friday
            case 7:
                self.dayOfWeek = .Saturday
            default:
                self.dayOfWeek = .Monday
            }
    }
    
    enum DayOfWeek: String {
        case Sunday = "Sunday"
        case Monday = "Monday"
        case Tuesday = "Tuesday"
        case Wednesday = "Wednesday"
        case Thursday = "Thursday"
        case Friday = "Friday"
        case Saturday = "Saturday"
        
        
    }
}