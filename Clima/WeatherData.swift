
import Foundation

// you can have more than one protocol and if it's used often it can have a type Alias. ex: Decodable, Encodable get used enough we can call it Codable
struct WeatherData: Decodable {
    let name: String
    let main: Main
    // this is to access an array inside a JSON object. I created the object called weather
    let weather: [Weather]
}

// this is how you would break down a JSON object.
struct Main: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Int
} 


struct Weather: Decodable {
    let id: Int
    let description: String
}


