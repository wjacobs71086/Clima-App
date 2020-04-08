

import Foundation


struct WeatherManager {
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
                    self.parseJSON(weatherData: safeData)
                }
            }
            // 4. Start the task. Because they BEGIN in a suspended state
            task.resume()
        }
    }
    func parseJSON(weatherData: Data){
        let decoder = JSONDecoder()
        do{
            // the .self is AFTER the struct to show its data TYPE but not the content.
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            getCondition(weatherId: id)
        } catch {
            print(error)
        }
    }
    
    func getCondition(weatherId: Int) -> String {
        switch weatherId {
        case 200..<300:
            return "cloud.bolt.rain"
        case 300..<400:
            return "cloud.drizzle"
        case 500..<600:
            return "cloud.rain"
        case 600..<700:
            return "cloud.snow"
        case 701...800:
            return "cloud.fog"
        case 800:
            return "sun.min"
        case 801...804:
            return "cloud"
        default:
            return "cloud.fill"
        }
    }
    
}
