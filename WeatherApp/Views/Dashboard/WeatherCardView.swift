import SwiftUI

struct WeatherCardView: View {
    let card: WeatherCard
    @State private var isPressed = false
    
    private var cardGradient: [Color] {
        switch card.condition {
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
    }
    
    var body: some View {
        NavigationLink(destination: WeatherDetailView(weather: card.toWeatherDetail())) {
            HStack(spacing: 16) {
                // Temperature and location info
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(card.temperature)°")
                        .font(.system(size: 48, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text("H:\(card.highTemp)° L:\(card.lowTemp)°")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("\(card.cityName), \(card.country)")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // Weather condition
                VStack(alignment: .trailing, spacing: 4) {
                    WeatherConditionIcon(condition: card.condition)
                        .frame(width: 60, height: 60)
                    
                    Text(card.condition.description)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: cardGradient),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: cardGradient[0].opacity(0.3), radius: 10, x: 0, y: 5)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
} 
