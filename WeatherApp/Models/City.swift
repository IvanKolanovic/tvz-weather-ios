import Foundation
import CoreData

struct City: Identifiable {
    let id: UUID
    let name: String
    let country: String
    let latitude: Double
    let longitude: Double
    
    init(id: UUID = UUID(), name: String, country: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(entity: SavedCity) {
        self.id = entity.id ?? UUID()
        self.name = entity.name ?? ""
        self.country = entity.country ?? ""
        self.latitude = entity.latitude
        self.longitude = entity.longitude
    }
    
    static var defaultCities: [City] = [
        City(name: "Montreal", country: "Canada", latitude: 45.5017, longitude: -73.5673),
        City(name: "Toronto", country: "Canada", latitude: 43.6532, longitude: -79.3832),
        City(name: "Tokyo", country: "Japan", latitude: 35.6762, longitude: 139.6503),
        City(name: "Tennessee", country: "United States", latitude: 35.5175, longitude: -86.5804)
    ]
    
    static func getCity(name: String, country: String) -> City? {
        defaultCities.first { $0.name == name && $0.country == country }
    }
} 
