import SwiftUI

struct ThirdOnboardingView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "bell.badge.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 200)
                .foregroundColor(.white)
                .padding(.bottom, 40)
            
            VStack(spacing: 16) {
                Text("Weather Alerts")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Stay informed with real-time weather alerts and notifications")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.horizontal)
            }
            
            Spacer()
            Spacer()
        }
        .padding()
    }
} 
