import SwiftUI
import CoreData

@main
struct WeatherApp: App {
    @StateObject private var appState = AppState.shared
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            if appState.hasCompletedOnboarding {
                DashboardView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                OnboardingView()
            }
        }
    }
} 