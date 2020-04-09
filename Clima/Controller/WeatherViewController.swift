

import UIKit


class WeatherViewController: UIViewController {
    
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
        
        print("you crazy bastard",weather.temperatureString)
    }
    
    func didFail(_ error: Error) {
        print(error)
    }
}

