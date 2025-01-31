import SwiftUI

extension Color {
    static let customPalette = CustomPalette()
}

struct CustomPalette {
    // Main colors
    let primary = Color(hex: "2C2C5C")     // Lighter navy blue
    let secondary = Color(hex: "383875")    // Even lighter navy blue
    
    // Weather condition gradients
    var clearSkyGradient: [Color] {
        [Color(hex: "FF8339"), Color(hex: "FF5B64")] // Warm orange to pink
    }
    
    var partlyCloudyGradient: [Color] {
        [Color(hex: "87CEEB"), Color(hex: "4682B4")] // Sky blue to steel blue
    }
    
    var cloudyGradient: [Color] {
        [Color(hex: "708090"), Color(hex: "4A4A4A")] // Slate gray to dark gray
    }
    
    var rainGradient: [Color] {
        [Color(hex: "4B7BE5"), Color(hex: "3461C7")] // Blue shades
    }
    
    var snowGradient: [Color] {
        [Color(hex: "59B7E0"), Color(hex: "3E9ECA")] // Ice blue shades
    }
    
    var thunderstormGradient: [Color] {
        [Color(hex: "2F4F4F"), Color(hex: "191970")] // Dark slate to midnight blue
    }
    
    var fogGradient: [Color] {
        [Color(hex: "B8B8B8"), Color(hex: "6B6B6B")] // Light gray to medium gray
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 