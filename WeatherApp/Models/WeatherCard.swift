import Foundation

struct WeatherCard: Identifiable {
    let id = UUID()
    let cityName: String
    let country: String
    var temperature: Int
    var highTemp: Int
    var lowTemp: Int
    var condition: WeatherCondition
    
    var city: City? {
        City.getCity(name: cityName, country: country)
    }
}

enum WeatherCondition {
    case clearSky
    case partlyCloudy
    case cloudy
    case rain
    case snow
    case thunderstorm
    case fog
    
    init(weatherCode: Float) {
        // WMO Weather interpretation codes (WW)
        // https://open-meteo.com/en/docs
        switch Int(weatherCode) {
        case 0: // Clear sky
            self = .clearSky
        case 1, 2: // Partly cloudy
            self = .partlyCloudy
        case 3: // Overcast
            self = .cloudy
        case 51, 53, 55, 61, 63, 65, 80, 81, 82: // Rain
            self = .rain
        case 71, 73, 75, 77, 85, 86: // Snow
            self = .snow
        case 95, 96, 99: // Thunderstorm
            self = .thunderstorm
        case 45, 48: // Fog
            self = .fog
        default:
            self = .clearSky
        }
    }
    
    var description: String {
        switch self {
        case .clearSky:
            return "Clear Sky"
        case .partlyCloudy:
            return "Partly Cloudy"
        case .cloudy:
            return "Cloudy"
        case .rain:
            return "Rain"
        case .snow:
            return "Snow"
        case .thunderstorm:
            return "Thunderstorm"
        case .fog:
            return "Fog"
        }
    }
    
    var iconName: String {
        switch self {
        case .clearSky:
            return "sun.max.fill"
        case .partlyCloudy:
            return "cloud.sun.fill"
        case .cloudy:
            return "cloud.fill"
        case .rain:
            return "cloud.rain.fill"
        case .snow:
            return "cloud.snow.fill"
        case .thunderstorm:
            return "cloud.bolt.fill"
        case .fog:
            return "cloud.fog.fill"
        }
    }
}

extension WeatherCard {
    func toWeatherDetail() -> WeatherDetail {
        let hourlyData = (0..<24).map { hour in
            HourlyForecast(
                time: Calendar.current.date(byAdding: .hour, value: hour, to: Date()) ?? Date(),
                temperature: temperature + Int.random(in: -5...5),
                condition: condition
            )
        }
        
        return WeatherDetail(
            location: cityName,
            country: country,
            currentTemp: temperature,
            highTemp: highTemp,
            lowTemp: lowTemp,
            condition: condition,
            hourlyForecast: hourlyData,
            description: "Mostly sunny throughout the day",
            uv: 2,
            windSpeed: 23,
            date: Date(),
            coordinates: city.map { Coordinates(latitude: $0.latitude, longitude: $0.longitude) } ?? Coordinates(latitude: 0, longitude: 0)
        )
    }
} 