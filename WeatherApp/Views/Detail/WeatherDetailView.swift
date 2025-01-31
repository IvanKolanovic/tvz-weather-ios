import SwiftUI
import CoreData

struct WeatherDetailView: View {
    let weather: WeatherDetail
    @StateObject private var viewModel = WeatherViewModel()
    @Environment(\.dismiss) private var dismiss
    
    private var backgroundGradient: LinearGradient {
        let colors: [Color] = {
            switch weather.condition {
            case .clearSky:
                return Color.customPalette.clearSkyGradient
            case .partlyCloudy:
                return Color.customPalette.partlyCloudyGradient
            case .cloudy:
                return Color.customPalette.cloudyGradient
            case .rain:
                return Color.customPalette.rainGradient
            case .snow:
                return Color.customPalette.snowGradient
            case .thunderstorm:
                return Color.customPalette.thunderstormGradient
            case .fog:
                return Color.customPalette.fogGradient
            }
        }()
        
        return LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    // Header with location and time
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.caption)
                            Text("\(weather.location), \(weather.country)")
                        }
                        
                        Spacer()
                        
                        Text("Today, \(weather.date.formatted(date: .abbreviated, time: .shortened))")
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    
                    // Main temperature display
                    if let weatherData = viewModel.weatherData {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("\(Int(weatherData.current.temperature2m))°C")
                                .font(.system(size: 96, weight: .thin))
                            
                            Text("Real feel \(Int(weatherData.current.apparentTemperature))°")
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 20)
                        
                        // Weather metrics
                        HStack(spacing: 20) {
                            WeatherMetricCard(
                                title: "Wind",
                                value: "\(Int(weatherData.current.windSpeed10m)) km/h"
                            )
                            WeatherMetricCard(
                                title: "Humidity",
                                value: "\(Int(weatherData.current.relativeHumidity2m))%"
                            )
                            WeatherMetricCard(
                                title: "Pressure",
                                value: "\(Int(weatherData.current.pressureMsl)) hPa"
                            )
                        }
                        .padding()
                        
                        // Hourly forecast
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Hourly Forecast")
                                .font(.headline)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(Array(zip(weatherData.hourly.time, weatherData.hourly.temperature2m)), id: \.0) { time, temp in
                                        VStack(spacing: 8) {
                                            Text(time.formatted(.dateTime.hour()))
                                                .font(.caption)
                                            
                                            Text("\(Int(temp))°")
                                                .font(.system(.body, design: .rounded))
                                        }
                                        .foregroundColor(.white)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(20)
                        .padding()
                        
                        // Yesterday comparison
                        HStack {
                            Image(systemName: "clock.arrow.circlepath")
                            Text("Yesterday")
                            Text("↑\(weather.highTemp)° ↓\(weather.lowTemp)°")
                            Text("Light Rain Showers")
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        
                        Spacer()
                        
                        // Page indicators
                        HStack(spacing: 4) {
                            ForEach(0..<5) { i in
                                Circle()
                                    .fill(i == 0 ? Color.white : Color.white.opacity(0.3))
                                    .frame(width: 6, height: 6)
                            }
                        }
                        .padding(.bottom)
                    } else if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    }
                }
                .frame(minHeight: geometry.size.height)
            }
            .scrollContentBackground(.hidden)
            .background(backgroundGradient.ignoresSafeArea())
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
        }
        .task {
            await viewModel.fetchWeather(
                latitude: weather.coordinates.latitude,
                longitude: weather.coordinates.longitude
            )
        }
    }
}

struct WeatherMetricCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            
            Text(value)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
} 
