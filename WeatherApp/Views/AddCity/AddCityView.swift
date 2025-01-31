import SwiftUI

struct AddCityView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = WeatherViewModel()
    @ObservedObject private var appState = AppState.shared
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .onChange(of: searchText) { newValue in
                        Task {
                            try? await viewModel.searchCity(query: newValue)
                        }
                    }
                
                if viewModel.isSearching {
                    ProgressView()
                        .tint(.gray)
                } else {
                    List(viewModel.searchResults) { result in
                        Button {
                            let newCity = City(
                                name: result.name,
                                country: result.country,
                                latitude: result.latitude,
                                longitude: result.longitude
                            )
                            appState.addCity(newCity)
                            dismiss()
                        } label: {
                            VStack(alignment: .leading) {
                                Text(result.name)
                                    .font(.headline)
                                
                                Text("\(result.admin1 ?? ""), \(result.country)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add City")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
} 