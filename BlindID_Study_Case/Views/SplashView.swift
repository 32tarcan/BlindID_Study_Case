import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var rotationAngle = 0.0
    @State private var textScale = 0.5
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Image(systemName: "play.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.red)
                    .rotationEffect(.degrees(rotationAngle))
                    .scaleEffect(isAnimating ? 1.2 : 0.5)
                    .opacity(isAnimating ? 1 : 0)
                    .blur(radius: isAnimating ? 0 : 10)
                
                Text("BlindID")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .scaleEffect(textScale)
                    .opacity(isAnimating ? 1 : 0)
                    .blur(radius: isAnimating ? 0 : 5)
                
                if isAnimating {
                    Text("Movies & TV Shows")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.gray)
                        .transition(.opacity.combined(with: .scale))
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0.6)) {
                isAnimating = true
                textScale = 1.0
            }
            
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
            
            // Reset rotation for continuous spin
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                if rotationAngle == 360 {
                    rotationAngle = 0
                    withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: false)) {
                        rotationAngle = 360
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
} 