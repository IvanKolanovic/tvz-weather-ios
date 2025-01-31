import Foundation

struct WeatherData {
    let current: Current
    let hourly: Hourly
    let daily: Daily
    
    struct Current {
        let time: Date
        let temperature2m: Float
        let relativeHumidity2m: Float
        let apparentTemperature: Float
        let isDay: Float
        let precipitation: Float
        let rain: Float
        let showers: Float
        let snowfall: Float
        let weatherCode: Float
        let cloudCover: Float
        let pressureMsl: Float
        let surfacePressure: Float
        let windSpeed10m: Float
        let windDirection10m: Float
        let windGusts10m: Float
    }
    
    struct Hourly {
        let time: [Date]
        let temperature2m: [Float]
        let relativeHumidity2m: [Float]
        let apparentTemperature: [Float]
        let rain: [Float]
        let showers: [Float]
        let snowfall: [Float]
        let snowDepth: [Float]
        let weatherCode: [Float]
        let cloudCover: [Float]
        let cloudCoverLow: [Float]
        let cloudCoverHigh: [Float]
        let visibility: [Float]
        let windSpeed10m: [Float]
        let windSpeed80m: [Float]
        let uvIndex: [Float]
        let uvIndexClearSky: [Float]
        let isDay: [Float]
    }
    
    struct Daily {
        let time: [Date]
        let temperature2mMax: [Float]
        let temperature2mMin: [Float]
        let sunrise: [Float]
        let sunset: [Float]
        let daylightDuration: [Float]
        let sunshineDuration: [Float]
        let uvIndexMax: [Float]
        let uvIndexClearSkyMax: [Float]
        let rainSum: [Float]
    }
} 