//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    //MARK: - IBOutles
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    //MARK: - Public variables
    var weatherManager = WeatherManager()
    var weatherViewModel: WeatherModel?
    {
        didSet {
            updateUI(model: weatherViewModel!)
        }
    }
    
    let locationManager = CLLocationManager()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
        requestPermissions()
        initServices()
    }
    
    func updateUI(model: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = model.temperatureString
            self.cityLabel.text = model.cityName
            self.conditionImageView.image = UIImage(systemName: model.conditionName)
        }
    }
    
    func setDelegates() {
        weatherManager.delegate = self
        searchTextField.delegate = self
        locationManager.delegate = self
    }
    
    func requestPermissions() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func initServices() {
        locationManager.requestLocation()
    }
}

//MARK: - UIImage extension implementation
extension UIImageView {
    
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

//MARK: - WeatherManagerDelegate implementation
extension WeatherViewController : WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        weatherViewModel = weather
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - UITextFieldDelegate implementation
extension WeatherViewController :  UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchText = searchTextField.text else { return false}
        searchTextField.endEditing(true)
        print(searchText)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
            
            //conditionImageView.downloaded(from: "https://openweathermap.org/img/wn/10d.png", contentMode: .scaleToFill)
        }
        
        searchTextField.text = ""
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        guard let searchText = searchTextField.text else { return }
        
        searchTextField.endEditing(true)
        print(searchText)
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//MARK: - CLLocationManagerDelegate imlpementation

extension WeatherViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            weatherManager.fetchWeather(coordinate: location.coordinate)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
