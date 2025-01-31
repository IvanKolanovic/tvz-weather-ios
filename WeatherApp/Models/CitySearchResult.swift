import Foundation

struct CitySearchResult: Codable, Identifiable {
    let id = UUID()
    let name: String
    let country: String
    let latitude: Double
    let longitude: Double
    let admin1: String?  // State/Province
    
    enum CodingKeys: String, CodingKey {
        case name, country, latitude, longitude, admin1
    }
}

struct GeocodingResponse: Codable {
    let results: [CitySearchResult]?
    let generationtime_ms: Double
} 