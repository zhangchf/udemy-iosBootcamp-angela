//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, CityNameChangedDelegate {
    
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
//    let APP_ID = "612ba3b2b8ebe9794918fe013f1e2681"
    

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    var weatherDataModel: WeatherDataModel?

    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    //MARK: - Networking
    /***************************************************************/
    //Write the getWeatherData method here:
    
    func getWeatherData(params: [String: String]) {
        var newParams = params
        newParams["APPID"] = APP_ID
        Alamofire.request(WEATHER_URL, method: .get, parameters: newParams).responseJSON {
            response in
            if response.result.isSuccess {
                ProgressHUD.showSuccess("Get weather succeed")
                print("Get weather succeed", response)
                self.updateWeatherData(json: JSON(response.result.value!))
            } else {
                ProgressHUD.showError(response.error?.localizedDescription)
                print("Get weather failed", response)
            }
        }
    }
    
    //MARK: - JSON Parsing
    /***************************************************************/
    //Write the updateWeatherData method here:
    func updateWeatherData(json: JSON) {
        print(json)
        if let cityName = json["name"].string {
            let temperature = json["main"]["temp"].doubleValue
            let weatherId = json["weather"]["id"].intValue
            self.weatherDataModel = WeatherDataModel(cityName: cityName, temperature: Int(temperature), weatherIconName: WeatherDataModel.updateWeatherIcon(condition: weatherId))
            print(self.weatherDataModel!)
            
            updateUIWithWeatherData()
        } else {
            print("WeatherDataError")
            let msg = json["message"].string
            ProgressHUD.showError(msg)
        }
    }
    
    //MARK: - UI Updates
    /***************************************************************/
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData() {
        if let weatherDataModel = weatherDataModel {
            cityLabel.text = weatherDataModel.cityName
            temperatureLabel.text = "\(weatherDataModel.temperature - 273)°"
            weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        }
    }
    
    func updateUIWhenError() {
        cityLabel.text = "Can't get location..."
    }
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("did update locations")
        let lastLocation = locations[locations.count - 1]
        if lastLocation.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            var params = [String : String]()
            params["lon"] = String(lastLocation.coordinate.longitude)
            params["lat"] = String(lastLocation.coordinate.latitude)
            getWeatherData(params: params)
        } else {
            updateUIWhenError()
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager didFailWithError")
        updateUIWhenError()
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    //Write the userEnteredANewCityName Delegate method here:

    func onCityNameChanged(newName: String) {
        var params = [String: String]()
        params["q"] = newName
        getWeatherData(params: params)
    }
    

    
    //Write the PrepareForSegue Method here
    
    @IBAction func goChangeCity(_ sender: Any) {
        performSegue(withIdentifier: "changeCityName", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.cityNameChangedDelegate = self
        }
    }
    
}


