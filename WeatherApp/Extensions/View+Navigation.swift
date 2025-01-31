import SwiftUI

extension View {
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor(color)
        ]
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor(color)
        ]
        return self
    }
} 