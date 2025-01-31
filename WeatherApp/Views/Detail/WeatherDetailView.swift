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
                                .font(.title3)
                            Text("\(weather.location), \(weather.country)")
                                .font(.title3)
                        }
                        
                        Spacer()
                        
                        Text("Today, \(weather.date.formatted(date: .abbreviated, time: .shortened))")
                            .font(.title3)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Main temperature display
                    if let weatherData = viewModel.weatherData {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("\(Int(weatherData.current.temperature2m))°C")
                                .font(.system(size: 120, weight: .thin))
                            
                            Text("Real feel \(Int(weatherData.current.apparentTemperature))°")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 30)
                        
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
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Hourly Forecast")
                                .font(.title2)
                                .bold()
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 30) {
                                    ForEach(Array(zip(weatherData.hourly.time, weatherData.hourly.temperature2m)), id: \.0) { time, temp in
                                        VStack(spacing: 12) {
                                            Text(time.formatted(.dateTime.hour()))
                                                .font(.title3)
                                            
                                            Text("\(Int(temp))°")
                                                .font(.system(.title2, design: .rounded))
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
                                .font(.title3)
                            Text("Yesterday")
                                .font(.title3)
                            Text("↑\(weather.highTemp)° ↓\(weather.lowTemp)°")
                                .font(.title3)
                            Text("Light Rain Showers")
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.vertical)
                        
                        Spacer()
                    } else if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.5)
                            .padding(.top, 50)
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
                        .font(.title2)
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
        VStack(spacing: 12) {
            Text(title)
                .font(.title3)
                .foregroundColor(.white.opacity(0.7))
            
            Text(value)
                .font(.system(.title2, design: .rounded))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
    }
} 
