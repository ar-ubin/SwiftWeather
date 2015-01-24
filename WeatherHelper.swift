//
//  WeatherHelper.swift
//  Weather
//
//  Created by student on 21.01.15.
//  Copyright (c) 2015 student. All rights reserved.
//
import UIKit

protocol WeatherHelperProtocol {
    
    func receiveLocation(location: Location)
    func receiveError()
}

class WeatherHelper {
    
    var delegate: WeatherHelperProtocol!
    
    init(){}

    func weather(numberOfDays: Int, city: String) {
        let encodedCity = city.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        call("http://api.openweathermap.org/data/2.5/forecast/daily?q=\(encodedCity)&mode=json&units=metric&cnt=\(numberOfDays)");
    }
    
    func getWeatherIcon(iconCode: String) -> UIImage {
        
        var url = NSURL(string: "http://openweathermap.org/img/w/\(iconCode).png")
        let data = NSData(contentsOfURL: url!)
        
        let weatherIcon:UIImage = UIImage(data: data!)! //Falschen Code abfangen
        
        return weatherIcon
    }
    
    private func call(url: String) {
        let weatherUrl = url
        
        let request = NSURLRequest(URL: NSURL(string: weatherUrl)!)
        let currentQueue = NSOperationQueue.currentQueue();
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError?) -> Void in
            var error: NSError? = error
            
            if error != nil {
                self.delegate?.receiveError()
                return
            }
            
            let json = JSON(data: data)
            
            let location = self.parseJsonToLocation(json)
            
            if(location.weather.isEmpty){
                self.delegate?.receiveError()
                return
            }
            
            self.delegate?.receiveLocation(location)
        }
    }

    func parseJsonToLocation(json:JSON) -> Location {
        
        var forecasts = [Forecast]()
    
        let forecastArray = json["list"].arrayValue
        
        for json in forecastArray {
            
            let dt = json["dt"].int ?? 0
            let tempDay = json["temp"]["day"].double ?? 0.0
            let tempNight = json["temp"]["night"].double ?? 0.0
            let tempMax = json["temp"]["max"].double ?? 0.0
            let tempMin = json["temp"]["min"].double ?? 0.0
            let pressure = json["pressure"].int ?? 0
            let humidity = json["humidity"].int ?? 0
            let weatherId = json["weather"][0]["id"].int ?? 0
            let waetherMain = json["weather"][0]["main"].string ?? ""
            let weatherDesc = json["weather"][0]["description"].string ?? ""
            let weatherIcon = json["weather"][0]["icon"].string ?? ""
            
            let date = NSDate(timeIntervalSince1970: NSTimeInterval(dt))
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.WeekdayCalendarUnit, fromDate: date)
            let weekDay = components.weekday
            
            var forecast = Forecast(dt: date, dayOfWeek: weekDay, tempDay: tempDay, tempNight: tempNight, tempMax: tempMax, tempMin: tempMin, pressure: pressure, humidity: humidity, weatherId: weatherId, weatherMain: waetherMain, weatherDesc: weatherDesc, weatherIcon: weatherIcon)
            
            forecasts.append(forecast)
        }
        
        let cityId = json["city"]["id"].int ?? 0
        let city = json["city"]["name"].string ?? "Wuerzburg"
        let lat = json["city"]["coord"]["lat"].double ?? 0.0
        let lon = json["city"]["coord"]["lon"].double ?? 0.0
        let country = json["city"]["country"].string ?? "DE"
        
        let locationNew:Location = Location(ID: cityId, name: city, lat: lat, lon: lon, message: "", country: country, weather: forecasts)
        
        return locationNew
    }
}
