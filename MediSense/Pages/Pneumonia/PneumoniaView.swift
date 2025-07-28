import SwiftUI

struct PneumoniaView: View {
    @State private var isResultViewActive = false
    @Environment(\.dismiss) private var dismiss
        
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    VStack(spacing: 16) {
                        
                        OpenCloseTextBox(title: "Overview", text: "Pneumonia is an air infection that inflames the air sacs in one or both lungs. The air sacs may fill with fluid or pus, causing cough, phlegm or pus, fever, chills, and difficulty breathing.", backgroundColor: .blue, textColor: .white)
                        
                        OpenCloseTextBox(title: "Symptoms", text: "- Chest pain during breathing or coughing\n- Confusion or changes in mental alertness\n- Below-normal body temperature\n- Nausea, vomiting, or diarrhea\n- Difficulty breathing or shortness of breath\n- Headache\n- Loss of appetite\n- Dizziness or feeling lightheaded\n- Weakness or numbness in the face, arms, or legs\n- Reduced awareness or responsiveness\n- Persistent cough\n- Fatigue or tiredness\n", backgroundColor: .blue, textColor: .white)
                        
                        OpenCloseTextBox(title: "Causes", text: "Many germs can cause pneumonia. The most common are bacteria and viruses in the air we breathe. Your body usually' 'prevents these germs from infecting your lungs. But sometimes these germs can overpower your immune system, even if' 'your health is generally good.' 'Pneumonia is classified according to the' ' Types of germs that cause it and where' 'you got the infection. Community-acquired pneumonia\n- Bacteria\n- Bacteria-like organisms\n- Fungi\n- Viruses.including COVID-19\nHospital-acquired pneumonia\nSome people catch pneumonia during a hospital stay for another illness. Hospital- acquired pneumonia can be serious because the people who get it already sick. Health care-acquired pneumonia It is a bacterial infection that occurs in people who live in long-term care facilities or who receive care in outpatient clinics.", backgroundColor: .blue, textColor: .white)
                        
                        OpenCloseTextBox(title: "Risk factors", text: "- Children who are 2years old or younger\n- People who are age 65 or older\n- Being Hospitalized\n- Chronic disease\n- Smoking\n- Weakened or suppressed immune\n- system\n- Shortness of breath"
                                         , backgroundColor: .red, textColor: .white)
                    }
                    
                    Divider()
                        .frame(height: 1)
                        .background(Color.blue)
                    
                    HStack(alignment: .center, spacing: 20) {
                        VStack {
                            Button(action: {
                                isResultViewActive = true
                            }) {
                                ZStack {
                                    Rectangle()
                                        .fill(Color.blue)
                                        .frame(width: 125, height: 125)
                                    Image(systemName: "photo.on.rectangle.angled")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.white)
                                }
                            }
                            Text("Pnumonia Detection")
                                .foregroundColor(Color.blue)
                                .font(.headline)
                        }
                    }
                    Divider()
                        .frame(height: 1)
                        .background(Color.blue)
                    Group {
                        Text("Preventation")
                            .font(.title2)
                            .bold()
                        Text("To help prevent pneumonia:\n- Get vaccinated\n- Practice good hygiene\n- Do not smoke\n- Keep your immune system strong")
                            .foregroundColor(.gray)
                            .font(.body)
                    }
                }
                .padding(.horizontal, 20)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                    }
                }

                ToolbarItem(placement: .principal) {
                    VStack(spacing: 2) {
                        Text("Pneumonia Detection")
                    }
                    .font(.headline)
                    .multilineTextAlignment(.center)
                }
            }
            .background(backgroundLinks(
                isResultViewActive: $isResultViewActive
            ))
        }
        .navigationBarBackButtonHidden(true)
    }
}

@ViewBuilder
private func backgroundLinks(
    isResultViewActive: Binding<Bool>
) -> some View {
    Group {
        NavigationLink(
            destination: PneumoniaClassifyView(
                viewModel: AppViewModel(),
                lottieAnimationName: "pneumonia",
                imageMean: 244.0,
                imageStd: 244.0,
                numResults: 4,
                threshold: 0.2
            )
            .navigationBarBackButtonHidden(true),
            isActive: isResultViewActive
        ) {
            EmptyView()
        }
    }
}
