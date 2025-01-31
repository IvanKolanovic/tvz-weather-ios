import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @ObservedObject private var appState = AppState.shared
    @State private var searchText = ""
    @State private var weatherCards: [WeatherCard] = []
    @State private var isLoading = true
    @State private var showingAddCity = false
    @State private var cityToDelete: WeatherCard?
    @State private var isEditing = false
    
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
                                    .overlay(alignment: .topTrailing) {
                                        if isEditing {
                                            Button {
                                                cityToDelete = card
                                            } label: {
                                                Image(systemName: "minus.circle.fill")
                                                    .font(.title2)
                                                    .foregroundColor(.red)
                                                    .background(Circle().fill(.white))
                                            }
                                            .offset(x: 10, y: -10)
                                        }
                                    }
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
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation {
                            isEditing.toggle()
                        }
                    } label: {
                        Text(isEditing ? "Done" : "Edit")
                            .foregroundColor(.white)
                    }
                }
                
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
            .confirmationDialog(
                "Delete City",
                isPresented: Binding(
                    get: { cityToDelete != nil },
                    set: { if !$0 { cityToDelete = nil } }
                ),
                presenting: cityToDelete
            ) { card in
                Button("Delete \(card.cityName)", role: .destructive) {
                    deleteCity(card)
                    cityToDelete = nil
                    if weatherCards.isEmpty {
                        isEditing = false
                    }
                }
            } message: { card in
                Text("Are you sure you want to remove \(card.cityName) from your cities?")
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
    
    private func deleteCity(_ card: WeatherCard) {
        if let city = card.city {
            withAnimation {
                City.defaultCities.removeAll { $0.name == city.name && $0.country == city.country }
                weatherCards.removeAll { $0.id == card.id }
            }
        }
    }
} 
