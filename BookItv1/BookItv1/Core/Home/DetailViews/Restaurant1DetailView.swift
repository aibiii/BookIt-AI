import SwiftUI

struct Restaurant1DetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isChatViewActive = false
    var body: some View {
        VStack(spacing: 16) {
            Image("restaurant1Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .shadow(radius: 5)

            Text("Ресторан \"Рис\"")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            VStack(alignment: .center, spacing: 8) {
                Text("Корейская | Европейская | Японская")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Бухар Жырау 10:00-24:00 | ADK 10:00-24:00")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Бухар Жырау, 27/5а | ТРК ADK, 2 этаж")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            HStack(spacing: 20) {
                Link("Instagram", destination: URL(string: "https://www.instagram.com/ristorankz/")!)
                    .font(.subheadline)
                    .foregroundColor(.blue)

                Link("WhatsApp", destination: URL(string: "https://wa.me/77078000342")!)
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            .padding()
            Button(action: {
                isChatViewActive = true
            }) {
                Text("Сгенерировать текст")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(UIColor(red: 54/255, green: 54/255, blue: 53/255, alpha: 1.0)))
                    .cornerRadius(10)
            }
            .padding()
            .fullScreenCover(isPresented: $isChatViewActive) {
                ChatView(showChat: $isChatViewActive)
            }
        }
        .padding()
        .frame(width: .infinity, height: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color(red: 0.9333333333333333, green: 0.9176470588235294, blue: 0.8941176470588236))
                .shadow(color: Color.black.opacity(0.6), radius: 5, x: 0, y: 2)
        )
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }

    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                Text("Back")
            }
            .font(.headline)
            .foregroundColor(.primary)
        }
    }
}

struct Restaurant1DetailView_Previews: PreviewProvider {
    static var previews: some View {
        Restaurant1DetailView()
    }
}
