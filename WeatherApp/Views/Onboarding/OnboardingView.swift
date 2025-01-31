import SwiftUI

struct OnboardingView: View {
    @ObservedObject private var appState = AppState.shared
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.customPalette.primary,
                    Color.customPalette.secondary
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                TabView(selection: $currentPage) {
                    FirstOnboardingView()
                        .tag(0)
                    
                    SecondOnboardingView()
                        .tag(1)
                    
                    ThirdOnboardingView()
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                // Navigation buttons and page indicators
                VStack(spacing: 24) {
                    // Page indicators
                    HStack(spacing: 12) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(currentPage == index ? Color.white : Color.white.opacity(0.5))
                                .frame(width: 8, height: 8)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.spring(), value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        withAnimation {
                            if currentPage < 2 {
                                currentPage += 1
                            } else {
                                appState.completeOnboarding()
                            }
                        }
                    }) {
                        Text(currentPage == 2 ? "Get Started" : "Next")
                            .font(.headline)
                            .foregroundColor(Color.customPalette.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                }
                .padding(32)
            }
        }
    }
} 