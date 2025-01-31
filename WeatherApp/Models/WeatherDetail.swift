import Foundation

struct WeatherDetail {
    let location: String
    let country: String
    let currentTemp: Int
    let highTemp: Int
    let lowTemp: Int
    let condition: WeatherCondition
    let hourlyForecast: [HourlyForecast]
    let description: String
    let uv: Int
    let windSpeed: Int
    let date: Date
    let coordinates: Coordinates
}

struct HourlyForecast: Identifiable {
    let id = UUID()
    let time: Date
    let temperature: Int
    let condition: WeatherCondition
} 