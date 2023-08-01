import SwiftUI

struct HomeView: View {
    @Binding var showChat: Bool
    @State private var isPresentingChat = false

    var body: some View {
        ScrollView {
            VStack {
                Text("BookIt AI") // Add the title here
                    .font(Font.custom("Roboto", size: 30))
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.21176470588235294, green: 0.21176470588235294, blue: 0.20784313725490197))
                    .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
                    .padding(.bottom, 20)

                Rectangle()
                    .foregroundColor(Color(red: 0.9333333333333333, green: 0.9176470588235294, blue: 0.8941176470588236))
                    .frame(width: 338.0, height: 112.0)
                    .cornerRadius(22)
                    .shadow(color: Color.black.opacity(0.6), radius: 5, x: 0, y: 2)
                    .overlay(
                        Button(action: {
                            showChat = true
                        }) {
                            Text("Start the Chat")
                                .font(Font.custom("Roboto", size: 40))
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 0.21176470588235294, green: 0.21176470588235294, blue: 0.20784313725490197))
                                .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
                                .lineSpacing(22)
                                .kerning(-0.41)
                                .frame(width: 338.0, height: 112.0)
                        }
                    )
                    .padding(.bottom, 30)
                
                RestaurantRecommendationsView()
                    .padding(.bottom, 30)
                AboutView()
                    .padding(.bottom, 30)
                Spacer()
            }
            .padding()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(showChat: .constant(false))
    }
}
