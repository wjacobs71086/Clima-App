

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFail(_ error: Error)
}

struct WeatherManager {
    var delegate: WeatherManagerDelegate?
    
    let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=4908a00f0193f322aaa5d08a25f81607&units=imperial"
    
    // APPARENTLY Swift is okay with functions that have the same name as long as they require different parameters.
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(baseURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString)
    }
    
    func fetchWeather(city: String) {
        let encodedCityName = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseURL)&q=\(encodedCityName.lowercased())"
        performRequest(urlString)
    }
    
    func performRequest(_ urlString: String){
        // 1. Create a url, because this could fail, it is an optional using if LET syntax
        if let url = URL(string: urlString){
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
            // 3. Give the sesssion a task, the completion handler is called oddly because it will complete it at the run time
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFail(error!)
                    print("Error", error!)
                    return
                }
                if let safeData = data {
                    // because this is inside a closure Swift will not add the self. tag for you
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self , weather: weather)
                    }
                }
            }
            // 4. Start the task. Because they BEGIN in a suspended state
            task.resume()
        }
    }
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            // the .self is AFTER the struct to show its data TYPE but not the content.
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            // even if this is a function it's basically self calling.
            // print(weather.temperatureString)
            
        } catch {
            delegate?.didFail(error)
            return nil
        }
    }
}
