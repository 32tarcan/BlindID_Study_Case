import SwiftUI

struct MoviesView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Movies")
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Movies")
        }
    }
}
#Preview {
    MoviesView()
}
