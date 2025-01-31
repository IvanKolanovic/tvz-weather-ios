import Foundation
import CoreData

@MainActor
class AppState: ObservableObject {
    static let shared = AppState()
    
    @Published private(set) var hasCompletedOnboarding: Bool
    @Published private(set) var cities: [City] = []
    
    private let defaults = UserDefaults.standard
    private let onboardingKey = "hasCompletedOnboarding"
    private let context = PersistenceController.shared.container.viewContext
    
    private init() {
        self.hasCompletedOnboarding = defaults.bool(forKey: onboardingKey)
        loadCities()
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        defaults.set(true, forKey: onboardingKey)
        
        // Add default cities on first launch
        if cities.isEmpty {
            City.defaultCities.forEach { addCity($0) }
        }
    }
    
    private func loadCities() {
        let request = NSFetchRequest<SavedCity>(entityName: "SavedCity")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \SavedCity.dateAdded, ascending: true)]
        
        do {
            let savedCities = try context.fetch(request)
            cities = savedCities.map(City.init)
        } catch {
            print("Error loading cities: \(error)")
        }
    }
    
    func addCity(_ city: City) {
        let savedCity = SavedCity(context: context)
        savedCity.id = city.id
        savedCity.name = city.name
        savedCity.country = city.country
        savedCity.latitude = city.latitude
        savedCity.longitude = city.longitude
        savedCity.dateAdded = Date()
        
        PersistenceController.shared.save()
        loadCities()
    }
    
    func removeCity(_ city: City) {
        let request = NSFetchRequest<SavedCity>(entityName: "SavedCity")
        request.predicate = NSPredicate(format: "id == %@", city.id as CVarArg)
        
        do {
            let results = try context.fetch(request)
            results.forEach(context.delete)
            PersistenceController.shared.save()
            loadCities()
        } catch {
            print("Error removing city: \(error)")
        }
    }
} 