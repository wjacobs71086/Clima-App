//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit


class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        let userInput = searchTextField.text ?? "didn't catch that"
        searchTextField.endEditing(true)

        print(userInput)
        
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // This is a good time to validate the users input
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Must include City"
            return false
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // use this delegate method to use searchField.text to get the weather THEN reset.
        
        if let city = searchTextField.text {
            weatherManager.fetchWeather(city: city)
        }
        textField.placeholder = "Search"
        textField.text = ""
    }
    
    func didUpdateWeather(weather: WeatherModel) {

           DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
           }
    
        print("you crazy bastard",weather.temperatureString)
    }


}

