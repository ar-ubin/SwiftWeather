//
//  Location.swift
//  Weather
//
//  Created by student on 17.01.15.
//  Copyright (c) 2015 student. All rights reserved.
//

import UIKit
import MapKit

class Location: NSObject {
    
    let ID: Int
    let name: String
    let coordinates: CLLocationCoordinate2D
    let message : String
    let country: String
    var weather: [Forecast]
    
    init(ID: Int,
        name: String,
        lat: CLLocationDegrees,
        lon: CLLocationDegrees,
        message: String,
        country: String,
        weather: [Forecast]) {
            
            self.ID = ID
            self.name = name
            self.coordinates = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            self.message = message
            self.message = message
            self.country = country
            self.weather = weather
    }
}
