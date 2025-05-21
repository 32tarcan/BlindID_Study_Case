import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Profile")
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Profile")
        }
    }
}
#Preview {
    ProfileView()
}
