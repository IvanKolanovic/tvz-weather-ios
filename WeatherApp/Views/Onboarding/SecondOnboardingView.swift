import SwiftUI

struct SecondOnboardingView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "location.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 200)
                .foregroundColor(.white)
                .padding(.bottom, 40)
            
            VStack(spacing: 16) {
                Text("Location Based Weather")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Get accurate weather information based on your current location")
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
