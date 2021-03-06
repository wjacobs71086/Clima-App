

import UIKit
import CoreLocation

class WeatherViewController: UIViewController  {
    

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // This is going to prompt the user for permission to use their location
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
        weatherManager.delegate = self
        searchTextField.delegate = self
        
    }
    
    @IBAction func currentLocationButon(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}
// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
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
}

// MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager , weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFail(_ error: Error) {
        print(error)
    }
}

// MARK: - LocationDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: long)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("fail")
    }
}

