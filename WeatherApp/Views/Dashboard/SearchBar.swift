import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(isFocused || !text.isEmpty ? .black : .gray)
            
            TextField("Search city...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .focused($isFocused)
                .autocorrectionDisabled()
                .submitLabel(.search)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                    isFocused = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .transition(.scale)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal)
        .animation(.easeInOut(duration: 0.2), value: text)
    }
} 