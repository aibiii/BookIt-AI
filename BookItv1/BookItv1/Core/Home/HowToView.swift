import SwiftUI

struct HowToView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView { // Wrap the content in a ScrollView
            VStack {
                VStack(spacing: 20) {
                    Text("Как пользоваться?")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
                        .padding(.bottom, 20)
                        .padding(.top, 20)
                    
                    Text("Шаг 1: Перейдите по данной кнопке в чат.")
                        .font(.body)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading) // Align to leading edge
                    
                    Rectangle()
                        .foregroundColor(Color(red: 0.933, green: 0.918, blue: 0.894))
                        .frame(width: 300.0, height: 99)
                        .cornerRadius(15) // Smaller corner radius
                        .shadow(color: Color.black.opacity(0.6), radius: 5, x: 0, y: 2)
                        .overlay(
                            Text("Start the Chat")
                                .font(Font.custom("Roboto", size: 30)) // Smaller font size
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 0.212, green: 0.212, blue: 0.208))
                                .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
                                .lineSpacing(12) // Smaller line spacing
                                .frame(width: 250.0, height: 75.0) // Smaller frame size
                        )
                    
                    Text("Вы найдете кнопку в главном меню.")
                        .font(.body)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading) // Align to leading edge
                    
                    Text("Шаг 2: Вас поприветствует BookIt ассистент, который будет ожидать Ваших инструкций.")
                        .font(.body)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        // Bot message examples
                        MessageBubble(text: "Здравствуйте! Как я могу помочь вам сегодня?", isUser: false)
                            .frame(width: 250, height: 80)
                        Spacer()
                    }
                    HStack {
                        // Bot message examples
                        MessageBubble(text: "Вы можете предоставить данные о бронировании, например, 'Название локации, дату, время, количество людей/название процедуры, и имя на брони'", isUser: false)
                            .frame(width: 250, height: 180)
                        Spacer()
                    }
                    
                    Text("Пример сообщений которые Вы можете вводить:")
                        .font(.body)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Spacer()
                        MessageBubble(text: "3 человека, Aurora Cafe Shop, 23 ноября в 10:00, Карина", isUser: true)
                            .frame(width: 250, height: 90)
                    }
                    HStack {
                        Spacer()
                        MessageBubble(text: "VIVA Dostyk Plaza, завтра в 3.30, мужская стрижка, Азат", isUser: true)
                            .frame(width: 250, height: 80)
                    }
                }
                .padding(.horizontal, 20)
            .multilineTextAlignment(.leading)
            }
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("ОК")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.21176470588235294, green: 0.21176470588235294, blue: 0.20784313725490197))
                    .cornerRadius(12)
                    .frame(width: 350, height: 80)
            }
            .padding(.top, 20)
        }
    }
}

struct MessageBubble: View {
    var text: String
    var isUser: Bool = false

    var body: some View {
        ZStack {
            if isUser {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.blue)
            } else {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.gray)
            }

            Text(text)
                .font(.body)
                .foregroundColor(.white)
                .padding(.vertical, 8) // Adjust vertical padding
                .padding(.horizontal, 12) // Adjust horizontal padding
        }
    }
}

struct HowToView_Previews: PreviewProvider {
    static var previews: some View {
        HowToView()
    }
}
