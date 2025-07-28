import SwiftUI

struct IntroductionPage: View {
    
    @State private var navigate = false
    
    var body: some View {
            GeometryReader { geo in
                ZStack(alignment: .top) {
                    Color.white.ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        // Top image (doctor)
                        Image("doctor_AI")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: geo.size.height * 0.55)
                            .clipped()
                        Spacer()
                    }
                    
                    // Bottom white curved panel with scrollable content
                    VStack {
                        Spacer()
                        
                        ZStack(alignment: .bottom) {
                            RoundedTopWhiteContainer()
                                .fill(Color.white)
                                .frame(height: geo.size.height * 0.53)
                                .shadow(radius: 4)
                            
                            VStack(spacing: 16) {
                                VStack(spacing: 19) {
                                    Text("Welcome to MediSence AI")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(Color(hex: "#03045E"))
                                        .multilineTextAlignment(.center)
                                    
                                    Text("""
                                MediSense AI helps detect pneumonia, brain tumors, and heart disease risks using advanced AI. It then gathers key patient details like age, BMI, and blood pressure to offer personalized treatment advice, lifestyle tips, and lifespan insights.
                                """)
                                    .font(.system(size: 17))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 10)
                                }
                                .padding(.top, 10)
                                .padding(.bottom, 20)
                                .frame(maxWidth: geo.size.width * 0.85)
                                
                                Button(action: {
                                    navigate = true
                                }) {
                                    Text("Launch")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.blue) // Replace with your hex color if needed
                                        .cornerRadius(8)
                                }
                                .padding(.horizontal, 40)
                                .padding(.bottom, 20)
                                
                                // Hidden navigation link triggered by state
                                NavigationLink(destination:
                                                HomePageView()
                                    .navigationBarBackButtonHidden(true), isActive: $navigate) {
                                        EmptyView()
                                    }
                            }
                        }
                    }
                }
            }
        
    }
}
