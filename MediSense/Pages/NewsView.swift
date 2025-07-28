//
//  NewsView.swift
//  MediSense
//
//  Created by Dhaval Upendrakumar Trivedi on 26/07/25.
//

import SwiftUI

struct Article: Identifiable, Codable {
    let id = UUID()
    let title: String
    let link: String
    let image_url: String?
}

struct NewsResponse: Codable {
    let results: [Article]
}

class NewsViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var isLoading = false  // Add this line
    
    func fetchNews() {
            isLoading = true  // Start loading

            guard let url = URL(string: "https://newsdata.io/api/1/news?apikey=pub_662a01d206d64edcbb509cd21d3c7cf3&q=health+disease+ai&language=en") else {
                isLoading = false
                return
            }

            URLSession.shared.dataTask(with: url) { data, _, error in
                DispatchQueue.main.async {
                    self.isLoading = false  // Stop loading
                }

                if let data = data {
                    do {
                        let decoded = try JSONDecoder().decode(NewsResponse.self, from: data)
                        DispatchQueue.main.async {
                            self.articles = decoded.results
                        }
                    } catch {
                        print("Decoding error:", error)
                    }
                }
            }.resume()
        }
}

struct NewsListView: View {
    @StateObject var viewModel = NewsViewModel()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    VStack {
                        ProgressView()
                        Text("Loading news...")
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                    }
                } else {
                    List(viewModel.articles) { article in
                        HStack(alignment: .top) {
                            if let imageUrl = article.image_url,
                               let url = URL(string: imageUrl) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    Color.gray.opacity(0.2)
                                }
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            } else {
                                Color.gray.opacity(0.1)
                                    .frame(width: 80, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }

                            VStack(alignment: .leading, spacing: 5) {
                                Text(article.title)
                                    .font(.headline)
                                Link("Read more", destination: URL(string: article.link)!)
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .navigationTitle("Health AI News")
            .onAppear {
                viewModel.fetchNews()
            }
        }
    }
}
