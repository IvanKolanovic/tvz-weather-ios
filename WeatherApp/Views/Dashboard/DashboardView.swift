import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @ObservedObject private var appState = AppState.shared
    @State private var searchText = ""
    @State private var weatherCards: [WeatherCard] = []
    @State private var isLoading = true
    @State private var showingAddCity = false
    
    private var filteredCards: [WeatherCard] {
        if searchText.isEmpty {
            return weatherCards
        }
        return weatherCards.filter { card in
            card.cityName.lowercased().contains(searchText.lowercased()) ||
            card.country.lowercased().contains(searchText.lowercased())
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.customPalette.primary,
                        Color.customPalette.secondary
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredCards) { card in
                                WeatherCardView(card: card)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Atmos")
            .toolbarColorScheme(.light, for: .navigationBar)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CitySearchView()) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                    }
                }
            }
            .task {
                await loadWeatherData()
            }
        }
    }
    
    private func loadWeatherData() async {
        isLoading = true
        
        let initialCards = City.defaultCities.map { city in
            WeatherCard(
                cityName: city.name,
                country: city.country,
                temperature: 0,
                highTemp: 0,
                lowTemp: 0,
                condition: .clearSky
            )
        }
        
        var updatedCards: [WeatherCard] = []
        
        for card in initialCards {
            if let city = card.city {
                do {
                    let weatherData = try await viewModel.fetchCardWeather(
                        latitude: city.latitude,
                        longitude: city.longitude
                    )
                    
                    var updatedCard = card
                    updatedCard.temperature = Int(weatherData.currentTemp)
                    updatedCard.highTemp = Int(weatherData.highTemp)
                    updatedCard.lowTemp = Int(weatherData.lowTemp)
                    updatedCard.condition = WeatherCondition(weatherCode: weatherData.weatherCode)
                    updatedCards.append(updatedCard)
                } catch {
                    print("Error fetching weather for \(card.cityName): \(error)")
                    updatedCards.append(card)
                }
            }
        }
        
        weatherCards = updatedCards
        isLoading = false
    }
} 
