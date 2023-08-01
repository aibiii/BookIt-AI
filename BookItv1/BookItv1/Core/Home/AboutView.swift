import SwiftUI

struct AboutView: View {
    @State private var isExpanded = false // Track the expansion state

    var body: some View {
        VStack(spacing: 20){
            VStack(spacing: 20) {
                Text("Что такое BookIt AI?")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
                    .padding(.top, 20)
                    .padding(.bottom, 10)

                if isExpanded {
                    // Show the full text when expanded
                    ExpandedText("Приложение \"BookIT AI\" представляет собой инновационное решение, разработанное для упрощения процесса бронирования столиков в ресторанах и записей в салонах красоты. Оно уникально тем, что использует технологию генерации текста на основе модели GPT, что позволяет автоматически создавать тексты для бронирования на основе предоставленной информации.")
                    ExpandedText("Одной из главных проблем, с которой сталкиваются пользователи при бронировании, является поиск контактной информации и траты времени на организацию бронирования. \"BookIT AI\" решает эти проблемы, предлагая простой и удобный способ осуществления бронирования.")
                    ExpandedText("Когда пользователь вводит данные бронирования в любом удобном формате, например, дату, время, количество гостей и предпочтения, ассистент в приложении \"BookIT AI\" использует модель GPT для генерации соответствующего текста запроса. Этот текст запроса включает все необходимые детали и требования для бронирования столика в ресторане или записи в салоне красоты.")
                } else {
                    // Show the small text snippet with the expand button
                    SmallTextSnippet("\"BookIT AI\" приложение разработанное для упрощения процесса вашего бронирования.")
                }

                // Toggle the expansion state when the button is pressed
                Button(action: {
                    isExpanded.toggle()
                }) {
                    Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                        .font(.title)
                        .foregroundColor(.black)
                }
            }
            .padding()
            .background(Color(red: 0.9333333333333333, green: 0.9176470588235294, blue: 0.8941176470588236))
            .cornerRadius(10) // Apply corner radius to create rounded corners
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2) // Add shadow
        }
        .padding(.horizontal, 20)
        .multilineTextAlignment(.leading)
    }
}

// Custom view for the expanded text
struct ExpandedText: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.body)
            .foregroundColor(.black)
    }
}

// Custom view for the small text snippet
struct SmallTextSnippet: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        HStack {
            Text(text.prefix(80)) // Display only the first 80 characters of the text
                .font(.body)
                .foregroundColor(.black)
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}

