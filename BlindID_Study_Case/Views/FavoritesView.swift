import SwiftUI

struct FavoritesView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Favorites")
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    FavoritesView()
}
