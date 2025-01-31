import SwiftUI

struct WeatherConditionIcon: View {
    let condition: WeatherCondition
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Base cloud
            Image(systemName: condition.iconName)
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .opacity(condition == .clearSky ? 0 : 1)
            
            // Condition-specific overlays
            switch condition {
            case .rain:
                VStack {
                    Spacer()
                    HStack(spacing: 4) {
                        ForEach(0..<3) { _ in
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 8, height: 8)
                                .offset(y: isAnimating ? 10 : 0)
                                .animation(
                                    Animation.easeInOut(duration: 1)
                                        .repeatForever(autoreverses: true)
                                        .delay(Double.random(in: 0...0.5)),
                                    value: isAnimating
                                )
                        }
                    }
                }
                
            case .snow:
                VStack {
                    Spacer()
                    HStack(spacing: 4) {
                        ForEach(0..<3) { _ in
                            Image(systemName: "snowflake")
                                .font(.caption2)
                                .foregroundColor(.white)
                                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                                .animation(
                                    Animation.linear(duration: 2)
                                        .repeatForever(autoreverses: false),
                                    value: isAnimating
                                )
                        }
                    }
                }
                
            default:
                EmptyView()
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
} 