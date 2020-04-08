

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=4908a00f0193f322aaa5d08a25f81607&units=imperial"
    func fetchWeather(city: String) {
        let urlString = "\(baseURL)&q=\(city.lowercased())"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String){
        // 1. Create a url, because this could fail, it is an optional using if LET syntax
        if let url = URL(string: urlString){
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
            // 3. Give the sesssion a task, the completion handler is called oddly because it will complete it at the run time
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("Error", error!)
                    return
                }
                if let safeData = data {
                    // because this is inside a closure Swift will not add the self. tag for you
                    if let weather01 = self.parseJSON(weatherData: safeData){
                        self.delegate?.didUpdateWeather(weather: weather01)
                    }
                }
            }
            // 4. Start the task. Because they BEGIN in a suspended state
            task.resume()
        }
    }
    func parseJSON(weatherData: Data) -> WeatherModel? {
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
            print(error)
            return nil
        }
    }
    

    
}
