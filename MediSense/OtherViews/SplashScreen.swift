import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false

    var body: some View {
        NavigationStack {
            ZStack {
                if isActive {
                    IntroductionPage()
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                } else {
                    Color(.systemTeal)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        
                        LottieView(name: "doctor_online")
                              .frame(maxWidth: .infinity, maxHeight: 400)
                        
                        Text("MediSence AI")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(Color.black.opacity(0.7))
                            .padding(.bottom, 100)
                    }
                }
            }
            .animation(.easeInOut(duration: 1), value: isActive)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    isActive = true
                }
            }
        }
    }
}
