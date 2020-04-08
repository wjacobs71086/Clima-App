

import Foundation


struct WeatherModel {
    // These are STORED properties of the struct
    let conditionId: Int
    let cityName: String
    let temperature: Double
    // This is a COMPUTED property, it computes its values based on the other values.
    var conditionName: String {
        // If I wanted a second function to just call here thats fine OR
        // return getCondition(weatherId: conditionId)
        switch conditionId {
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
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    
    
    // Currently this is unused
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


