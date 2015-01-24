//
//  ViewController.swift
//  Weather
//
//  Created by student on 17.01.15.
//  Copyright (c) 2015 student. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WeatherHelperProtocol {
    
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityWeather: UILabel!
    @IBOutlet weak var cityTemp: UILabel!
    @IBOutlet weak var weatherMin: UILabel!
    @IBOutlet weak var weatherMax: UILabel!
    @IBOutlet weak var weatherMainImage: UIImageView!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var client = WeatherHelper()
    var forecast:[Forecast] = [Forecast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        initWeatherData()
    }
    
    func initWeatherData() {
            
        self.client.delegate = self
        
        self.client.weather(5, city: "Dubai")
    }
    
    func receiveLocation(location: Location) {
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            self.cityLabel.text = location.name
            self.cityWeather.text = location.weather[0].weatherMain
            self.cityTemp.text = "\(Int(location.weather[0].tempDay))°"
            self.weatherMin.text = "\(Int(location.weather[0].tempMin))°"
            self.weatherMax.text = "\(Int(location.weather[0].tempMax))°"
            
            var forecastWithoutCurrentDay:[Forecast] = location.weather
            forecastWithoutCurrentDay.removeAtIndex(0)
            
            self.forecast = forecastWithoutCurrentDay
            self.tableView.reloadData()
            
            
//            println(location.weather[0].weatherMain)
//            //Clouds Rain #4E83A7
//            //Sunny #74C3FA
//            //Snow #E9ECEF
//            if location.weather[0].weatherMain == "Sunny" {
//            self.view.backgroundColor = UIColor(red: 0x74/255, green: 0xc3/255, blue: 0xFa/255, alpha: 1.0)
//            }
//            if (location.weather[0].weatherMain == "Clouds") || (location.weather[0].weatherMain == "Rain") {
//            self.view.backgroundColor = UIColor(red: 0x4e/255, green: 0x83/255, blue: 0xa7/255, alpha: 1.0)
//            }
//            if location.weather[0].weatherMain == "Snow" {
//                self.view.backgroundColor = UIColor(red: 0xe9/255, green: 0xec/255, blue: 0xef/255, alpha: 1.0)
//            }


        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.count;
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("forecastCell") as ForecastCell
        
        // this is how you extract values from a tuple
        var day = forecast[indexPath.row]

        cell.weather.text = "\(day.dayOfWeek.rawValue)"
        cell.weather.sizeToFit()
        cell.weatherIcon.image = client.getWeatherIcon(day.weatherIcon)
        cell.weatherTempDay.text = "\(Int(day.tempDay))°"
        cell.weatherTempNight.text = "\(Int(day.tempNight))°"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        println("You selected cell #\(indexPath.row)!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

