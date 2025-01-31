import Foundation
import OpenMeteoSdk

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var weatherData: WeatherData?
    @Published var isLoading = false
    @Published var error: Error?
    @Published var searchResults: [CitySearchResult] = []
    @Published var isSearching = false
    
    func fetchWeather(latitude: Double, longitude: Double) async {
        isLoading = true
        
        do {
            let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,precipitation,rain,showers,snowfall,weather_code,cloud_cover,pressure_msl,surface_pressure,wind_speed_10m,wind_direction_10m,wind_gusts_10m&hourly=temperature_2m,relative_humidity_2m,apparent_temperature,rain,showers,snowfall,snow_depth,weather_code,cloud_cover,cloud_cover_low,cloud_cover_high,visibility,wind_speed_10m,wind_speed_80m,uv_index,uv_index_clear_sky,is_day&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset,daylight_duration,sunshine_duration,uv_index_max,uv_index_clear_sky_max,rain_sum&format=flatbuffers")!
            
            let responses = try await WeatherApiResponse.fetch(url: url)
            let response = responses[0]
            
            let utcOffsetSeconds = response.utcOffsetSeconds
            let current = response.current!
            let hourly = response.hourly!
            let daily = response.daily!
            
            self.weatherData = WeatherData(
                current: .init(
                    time: Date(timeIntervalSince1970: TimeInterval(current.time + Int64(utcOffsetSeconds))),
                    temperature2m: current.variables(at: 0)!.value,
                    relativeHumidity2m: current.variables(at: 1)!.value,
                    apparentTemperature: current.variables(at: 2)!.value,
                    isDay: current.variables(at: 3)!.value,
                    precipitation: current.variables(at: 4)!.value,
                    rain: current.variables(at: 5)!.value,
                    showers: current.variables(at: 6)!.value,
                    snowfall: current.variables(at: 7)!.value,
                    weatherCode: current.variables(at: 8)!.value,
                    cloudCover: current.variables(at: 9)!.value,
                    pressureMsl: current.variables(at: 10)!.value,
                    surfacePressure: current.variables(at: 11)!.value,
                    windSpeed10m: current.variables(at: 12)!.value,
                    windDirection10m: current.variables(at: 13)!.value,
                    windGusts10m: current.variables(at: 14)!.value
                ),
                hourly: .init(
                    time: hourly.getDateTime(offset: utcOffsetSeconds),
                    temperature2m: hourly.variables(at: 0)!.values,
                    relativeHumidity2m: hourly.variables(at: 1)!.values,
                    apparentTemperature: hourly.variables(at: 2)!.values,
                    rain: hourly.variables(at: 3)!.values,
                    showers: hourly.variables(at: 4)!.values,
                    snowfall: hourly.variables(at: 5)!.values,
                    snowDepth: hourly.variables(at: 6)!.values,
                    weatherCode: hourly.variables(at: 7)!.values,
                    cloudCover: hourly.variables(at: 8)!.values,
                    cloudCoverLow: hourly.variables(at: 9)!.values,
                    cloudCoverHigh: hourly.variables(at: 10)!.values,
                    visibility: hourly.variables(at: 11)!.values,
                    windSpeed10m: hourly.variables(at: 12)!.values,
                    windSpeed80m: hourly.variables(at: 13)!.values,
                    uvIndex: hourly.variables(at: 14)!.values,
                    uvIndexClearSky: hourly.variables(at: 15)!.values,
                    isDay: hourly.variables(at: 16)!.values
                ),
                daily: .init(
                    time: daily.getDateTime(offset: utcOffsetSeconds),
                    temperature2mMax: daily.variables(at: 0)!.values,
                    temperature2mMin: daily.variables(at: 1)!.values,
                    sunrise: daily.variables(at: 2)!.values,
                    sunset: daily.variables(at: 3)!.values,
                    daylightDuration: daily.variables(at: 4)!.values,
                    sunshineDuration: daily.variables(at: 5)!.values,
                    uvIndexMax: daily.variables(at: 6)!.values,
                    uvIndexClearSkyMax: daily.variables(at: 7)!.values,
                    rainSum: daily.variables(at: 8)!.values
                )
            )
            
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
        }
    }
    
    func fetchCardWeather(latitude: Double, longitude: Double) async throws -> CardWeatherData {
        let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m,weather_code&daily=temperature_2m_max,temperature_2m_min&format=flatbuffers")!
        
        let responses = try await WeatherApiResponse.fetch(url: url)
        let response = responses[0]
        
        let current = response.current!
        let daily = response.daily!
        
        return CardWeatherData(
            currentTemp: current.variables(at: 0)!.value,
            highTemp: daily.variables(at: 0)!.values[0],
            lowTemp: daily.variables(at: 1)!.values[0],
            weatherCode: current.variables(at: 1)!.value
        )
    }
    
    func searchCity(query: String) async throws {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        isSearching = true
        defer { isSearching = false }
        
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let url = URL(string: "https://geocoding-api.open-meteo.com/v1/search?name=\(encodedQuery)&count=10&language=en&format=json")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(GeocodingResponse.self, from: data)
        
        searchResults = response.results ?? []
    }
    
    func addCity(_ searchResult: CitySearchResult) {
        let newCity = City(
            name: searchResult.name,
            country: searchResult.country,
            latitude: searchResult.latitude,
            longitude: searchResult.longitude
        )
        
        // Add to cities array if it doesn't exist
        if !City.defaultCities.contains(where: { $0.name == newCity.name && $0.country == newCity.country }) {
            City.defaultCities.append(newCity)
        }
    }
}

struct CardWeatherData {
    let currentTemp: Float
    let highTemp: Float
    let lowTemp: Float
    let weatherCode: Float
} 
