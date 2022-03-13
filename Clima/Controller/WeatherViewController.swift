//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    var weatherViewModel: WeatherModel?
    {
        didSet {
            updateUI(model: weatherViewModel!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        guard let searchText = searchTextField.text else { return }
        
        searchTextField.endEditing(true)
        print(searchText)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchText = searchTextField.text else { return false}
        searchTextField.endEditing(true)
        print(searchText)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            print("did")
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
            
            conditionImageView.downloaded(from: "https://openweathermap.org/img/wn/10d.png", contentMode: .scaleToFill)
        }
        
        searchTextField.text = ""
    }
    
    func updateUI(model: WeatherModel) {
        temperatureLabel.text = model.temperatureString
        cityLabel.text = model.cityName
        conditionImageView.image = UIImage(named: model.conditionName)
    }
}

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

extension WeatherViewController : WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        weatherViewModel = weather
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
