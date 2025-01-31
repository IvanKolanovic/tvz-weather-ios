import SwiftUI

struct CitySearchView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = WeatherViewModel()
    @State private var searchText = ""
    @State private var debouncedText = ""
    @State private var showingError = false
    
    var body: some View {
        ZStack {
            Color.customPalette.primary
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Search field
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white.opacity(0.6))
                    
                    TextField("Search for a city...", text: $searchText)
                        .foregroundColor(.white)
                        .tint(.white)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .onChange(of: searchText) { newValue in
                            Task {
                                try? await Task.sleep(nanoseconds: 500_000_000)
                                if searchText == newValue {
                                    await performSearch()
                                }
                            }
                        }
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .padding()
                
                if viewModel.isSearching {
                    Spacer()
                    ProgressView()
                        .tint(.white)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.searchResults) { result in
                                CitySearchResultRow(result: result) {
                                    viewModel.addCity(result)
                                    dismiss()
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .navigationTitle("Add City")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func performSearch() async {
        do {
            try await viewModel.searchCity(query: searchText)
        } catch {
            showingError = true
        }
    }
}

struct CitySearchResultRow: View {
    let result: CitySearchResult
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 8) {
                Text(result.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("\(result.admin1 ?? ""), \(result.country)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(
                Color.white.opacity(0.1)
                    .cornerRadius(12)
            )
        }
        .buttonStyle(.plain)
        .padding(.vertical, 4)
    }
} 