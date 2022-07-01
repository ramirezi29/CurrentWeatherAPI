//
//  MainVC.swift
//  CurrentWeatherApp
//
//  Created by Ivan Ramirez on 2/3/22.
//

import UIKit
import CoreLocation

class MainVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mainNameLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var subDescriptionLabel: UILabel!
    @IBOutlet weak var mainDescriptionLabel: UILabel!
    
    // Location
    private let locationManger = CLLocationManager()
    
    private var coordinate = (myLat: "", myLong: "") {
        didSet {
            UpdateWeather(latValue: coordinate.myLat, longValue: coordinate.myLong)
        }
    }
    
    private let weatherController = WeatherController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Styling
        self.view.verticalGradient()
        //location
        locationManger.delegate = self
        //Location Details
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.distanceFilter = 10
        locationManger.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CLLocationManager.locationServicesEnabled() {
            UpdateWeather(latValue: coordinate.myLat, longValue: coordinate.myLong)
        }
    }
    
    func UpdateWeather(latValue: String, longValue: String) {
        
        weatherController.fetchWeather(lat: latValue, lon: longValue) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.failure(let error):
                print(error)
            case.success(let details):
                print(details)
                self.updateViews(weatherInfo: details)
            }
        }
    }
    
    func updateViews(weatherInfo: WeatherInfo) {
        
        Dispatch.DispatchQueue.main.async {
            self.mainDescriptionLabel.text = weatherInfo.weather.first?.main ?? "Info not found"
            self.subDescriptionLabel.text = weatherInfo.weather.first?.description ?? "Info not found"
            self.currentTempLabel.text = "Current Temp: \(weatherInfo.main.temp)°"
            self.minTempLabel.text = "Min Temp: \(weatherInfo.main.tempMin)°"
            self.maxTempLabel.text = "Max Temp: \(weatherInfo.main.tempMax)°"
            self.mainNameLabel.text = "City: \(weatherInfo.name)"
        }
    }
    
    
    //MARK: - Location
    // If the user has not granted permission then ask them for it by checking for the state of the authorization
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestAlwaysAuthorization()
        case .authorizedAlways , .authorizedWhenInUse:
            break
        case .denied, .restricted:
            break
        default:
            break
        }
        
        // Other things you can explore
        switch manager.accuracyAuthorization {
        case .fullAccuracy:
            break
        case .reducedAccuracy:
            break
        default:
            break
        }
        
        //we want to start updating the location
        manager.startUpdatingLocation()
    }
    
    // Other things to explore
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Status is the outcome of our ability to use their location, where were checking if there's been changes
        switch status {
        case .restricted:
            print("\nUsers location is restricted")
            
        case .denied:
            print("\nUser denied access to use their location\n")
            
        case .authorizedWhenInUse:
            print("\nUser granted authorizedWhenInUse\n")
            
        case .authorizedAlways:
            print("\nUser selected authorizedAlways\n")
            
        default: break
        }
    }
    
    //MARK: - Location movement updates
    
    //Updating the client's location on the terminal
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        coordinate = ("\(locationValue.latitude)", "\(locationValue.longitude)")
        
        //Testing
        print("🌎 didUpdateLocations: locations = \(locationValue.latitude) \(locationValue.longitude)")
    }
    
}
