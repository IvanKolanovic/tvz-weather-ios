import SwiftUI

struct FirstOnboardingView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Custom cloud with lightning
            ZStack {
                // Cloud
                Image(systemName: "cloud.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .foregroundColor(.white)
                
                // Lightning bolts
                HStack(spacing: 20) {
                    ForEach(0..<3) { _ in
                        Image(systemName: "bolt.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .foregroundColor(.yellow)
                    }
                }
                .offset(y: 20)
            }
            .padding(.bottom, 40)
            
            VStack(spacing: 16) {
                Text("Check real-time weather!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Amet minim mollit non deserunt ullamco est sit aliqua amet sint. Velit officia consequat enim velit mollit.")
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
