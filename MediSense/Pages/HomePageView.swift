import SwiftUI

struct DiseaseCardView: View {
    let image: String
    let diseaseName: String
    
    var body: some View {
        VStack {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 160, height: 160)
                .clipped()
            
            Text(diseaseName)
                .font(.system(size: 20))
                .foregroundColor(.black)
                .padding(.bottom, 10)
        }
        .frame(width: 160)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
        .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
    }
}

struct HomePageView: View {
    @StateObject private var viewModel = NewsViewModel()
    @State private var showNewsSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("home") // Make sure the image name matches
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
                
                VStack(alignment: .center, spacing: 30) {
                    
                    // Disease Detection Section
                    Text("Disease Detection")
                        .font(.title3)
                        .bold()
                        .foregroundColor(Color.black)
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.2))
                        )
                    
                    HStack (spacing: 20) {
                        NavigationLink( destination: PneumoniaView()) {
                            DiseaseCardView(image: "ic_lungs", diseaseName: "Pneumonia")
                        }
                        NavigationLink( destination: BrainTumourView()) {
                            DiseaseCardView(image: "ic_Brain_Cancer", diseaseName: "Brain Tumour")
                        }
                    }.padding(.horizontal)
                    
                    HStack {
                        NavigationLink( destination: HeartDiseaseView()) {
                            DiseaseCardView(image: "ic_heart_disease", diseaseName: "Heart Disease")
                        }
                    }.padding(.horizontal)
                    
                    
                    NavigationLink(destination: PatientInputView().navigationBarBackButtonHidden(true)) {
                        Text("Skip")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Circle().fill(Color.gray.opacity(0.6)))
                            .shadow(radius: 4)
                    }

                    // Top Health News Button
                    Button(action: {
                        showNewsSheet.toggle()
                    }) {
                        Text("Top Health News")
                            .font(.title3)
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .background(Color.white.opacity(0.2))
                            .foregroundColor(.primary)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showNewsSheet) {
                NewsListView()
            }
        }
    }
}

