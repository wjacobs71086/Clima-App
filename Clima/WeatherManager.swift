

import Foundation


struct WeatherManager {
    let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=4908a00f0193f322aaa5d08a25f81607&units=imperial"
    
    func fetchWeather(city: String) {
        let urlString = "\(baseURL)&q=\(city.lowercased())"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String){
        // 1. Create a url, because this could fail, it is an optional
        if let url = URL(string: urlString){
        // 2. Create a URLSession
            let session = URLSession(configuration: .default)
        // 3. Give the sesssion a task, the completion handler is called oddly because it will complete it at the run time
            let task = session.dataTask(with: url, completionHandler: handleResponse(data: response: error: ))
        // 4. Start the task. Because they BEGIN in a suspended state
            task.resume()
        }
    }
    
    func handleResponse(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            print("Error", error!)
            return
        }
        if let safeData = data {
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString!)
        }
    }
}
