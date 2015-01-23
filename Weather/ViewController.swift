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
        
        self.client.weather(5, city: "Wuerzburg")
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

