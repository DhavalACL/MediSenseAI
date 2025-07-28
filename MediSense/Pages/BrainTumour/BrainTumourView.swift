import SwiftUI

struct BrainTumourView: View {
    @State private var isResultViewActive = false
    @Environment(\.dismiss) private var dismiss
        
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    VStack(spacing: 16) {
                        
                        OpenCloseTextBox(title: "Overview", text: "A brain tumor is an abnormal mass or growth of cells within the brain. There are various types of brain tumors, which can be either noncancerous (benign) or cancerous (malignant). These tumors may originate in the brain itself, known as primary brain tumors, or they may develop from cancers that begin elsewhere in the body and spread to the brain, referred to as secondary (metastatic) brain tumors.", backgroundColor: .blue, textColor: .white)
                        
                        OpenCloseTextBox(title: "Symptoms", text: "Brain tumor symptoms vary based on the tumor's size, location, and growth rate. Common signs include frequent or worsening headaches, nausea, vision or hearing problems, balance and speech issues, seizures, fatigue, confusion, personality changes, and difficulty with movement or coordination.", backgroundColor: .blue, textColor: .white)
                        
                        OpenCloseTextBox(title: "Causes", text: "Brain tumors can either originate in the brain (primary) or spread from other parts of the body (secondary). Primary brain tumors start when normal brain cells undergo genetic mutations, leading to uncontrolled growth. They can develop in areas such as the meninges, cranial nerves, pituitary gland, or pineal gland. Common types include gliomas, meningiomas, acoustic neuromas, pituitary adenomas, medulloblastomas, germ cell tumors, and craniopharyngiomas. Secondary brain tumors, more common in adults, occur when cancer from other parts of the body spreads to the brain.", backgroundColor: .blue, textColor: .white)
                        
                        OpenCloseTextBox(title: "Risk factors", text: "The exact cause of most primary brain tumors is unknown, but certain risk factors may increase the chances of developing one. These include exposure to ionizing radiation (such as cancer treatment or atomic bomb radiation) and a family history of brain tumors or genetic conditions linked to them."
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
                            Text("Brain Tumour Detection")
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
                        Text("Unfortunately, you can’t prevent a brain tumor. You can reduce your risk of developing a brain tumor by avoiding environmental hazards such as smoking and excessive radiation exposure.")
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
                        Text("Brain Tumour Detection")
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
            destination: BrainTumourClassifyView(
                viewModel: AppViewModel(),
                lottieAnimationName: "brain_tumor",
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
