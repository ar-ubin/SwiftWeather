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
    
    @IBAction func editNewCity(sender: AnyObject) {
        editCity()
    }
    
    var client = WeatherHelper()
    var forecast:[Forecast] = [Forecast]()
    var currentCity: String = ""
    var loadScreen: LoadSreen!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setLoadingScreen()
        editCity()
    }
    
    func initWeatherData(city: String) {
       
        showLoadingScreen()
        
        self.client.delegate = self
        self.client.weather(5, city: city)
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
            
            self.hideLoadingScreen()
        }
    }
    
    func receiveError() {
        showErrorMessage()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.count;
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("forecastCell") as ForecastCell
      
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
    
    func showErrorMessage(){
        
        let alertController = UIAlertController(title: "Error", message:
            "Fail to load Data!", preferredStyle: UIAlertControllerStyle.Alert)
        
        let reloadAction = UIAlertAction(title: "Reload", style: .Default) { (action) in
            self.initWeatherData(self.currentCity)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (_) in }
        
        alertController.addAction(cancelAction)
        alertController.addAction(reloadAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func editCity(){
        
        let alertController = UIAlertController(title: "Edit City", message:
            "Access weather for entered City", preferredStyle: UIAlertControllerStyle.Alert)
        
        let editAction = UIAlertAction(title: "Edit", style: .Default) { (_) in
            let loginTextField = alertController.textFields![0] as UITextField
            
            self.currentCity = loginTextField.text
            self.initWeatherData(self.currentCity)
        }
        editAction.enabled = false
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "City"
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                editAction.enabled = textField.text != ""
            }
        }
    
        alertController.addAction(editAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func awakeFromNib() {
        let array = NSBundle.mainBundle().loadNibNamed("LoadScreen", owner: self, options: nil)
        self.loadScreen = array[0] as LoadSreen
    }
    
    func setLoadingScreen(){
        
        view.addSubview(loadScreen)
        
        loadScreen.frame = view.frame
        loadScreen.backgroundColor = loadScreen.backgroundColor?.colorWithAlphaComponent(0.9)
        loadScreen.alpha = 0.0
    }
    
    func hideLoadingScreen(){
        loadScreen.indicator.stopAnimating()
        loadScreen.alpha = 0.0
    }
    
    func showLoadingScreen(){
        loadScreen.indicator.startAnimating()
        loadScreen.alpha = 1.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

