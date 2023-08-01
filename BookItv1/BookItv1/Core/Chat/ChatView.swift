import SwiftUI
import Alamofire
import Firebase
import FirebaseFirestore

struct ChatView: View {
    @Binding var showChat: Bool
    
    @State var chatMessages: [ChatMessage] = ChatMessage.sampleMessages
    @State var messageText: String = ""
    @State var isGreetingSent: Bool = false
    @State var likedMessages: [LikedMessage] = []
    @State private var showAlert = false
    @State private var chatHistory: [Data] = []
    
    // Add a new property to handle the separate responses
    @State var phoneResponse: String = ""
    @State var bookingResponse: String = ""
    @State var whatsappResponse: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.showChat.toggle()
                }) {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .foregroundColor(.black)
                        .padding(10)
                }
                
                Spacer()
                
                Text("BookIt Bot")
                    .font(Font.custom("Roboto", size: 30))
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {}) {
                    Text("")
                }
                .padding(.trailing, 30) 
            }
            .padding(.horizontal)
            
            ScrollView {
                LazyVStack {
                    // Loop through the chatMessages array and display each message
                    ForEach(chatMessages, id: \.id) { message in
                        messageView(message: message)
                    }
                    
                    // Display the phoneResponse, bookingResponse, and whatsappResponse as separate messages
                    Text(phoneResponse)
                    Text(bookingResponse)
                    Text(whatsappResponse)
                }
            }
            
            HStack {
                TextField("Введите сообщение", text: $messageText)
                    .padding()
                    .background(Color(UIColor(red: 218/255, green: 214/255, blue: 207/255, alpha: 1.0)))
                    .cornerRadius(12)
                Button {
                    sendMessage()
                } label: {
                    Text("Send")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(UIColor(red: 54/255, green: 54/255, blue: 53/255, alpha: 1.0)))
                        .cornerRadius(12)
                }

            }
            
        }
        .padding()
        .onAppear {
            loadChatHistory()
            loadLikedMessages()
            
            if chatMessages.isEmpty && !isGreetingSent {
                displayGreetingMessage()
                isGreetingSent = true
            }
        }
        .onDisappear {
            // Save chat history to UserDefaults when the view disappears
            saveChatHistory()
        }
        .onTapGesture {
                hideKeyboard()
        }
    }
    
    func loadChatHistory() {
        if let data = UserDefaults.standard.value(forKey: "chatHistory") as? [Data] {
            chatHistory = data
            // Convert Data back to [ChatMessage] using Codable
            chatMessages = chatHistory.compactMap { data in
                try? JSONDecoder().decode(ChatMessage.self, from: data)
            }
        }
    }

    func saveChatHistory() {
        // Convert [ChatMessage] to [Data] using Codable
        chatHistory = chatMessages.compactMap { message in
            try? JSONEncoder().encode(message)
        }
        UserDefaults.standard.setValue(chatHistory, forKey: "chatHistory")
    }
    
    func loadLikedMessages() {
        if let userID = Auth.auth().currentUser?.uid {
            let likedMessageCollectionRef = Firestore.firestore().collection("users").document(userID).collection("likedMessages")
            likedMessageCollectionRef.addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching liked messages: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                likedMessages = documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: LikedMessage.self)
                }
            }
        }
    }

    func likeMessage(_ message: ChatMessage) {
        // Save the liked message to Firestore for the current user
        if let userID = Auth.auth().currentUser?.uid {
            let likedMessage = LikedMessage(id: message.id, content: message.content, dateLiked: Date())
            let likedMessageCollectionRef = Firestore.firestore().collection("users").document(userID).collection("likedMessages")

            do {
                try likedMessageCollectionRef.document(message.id).setData(from: likedMessage) { error in
                    if let error = error {
                        print("Error saving liked message: \(error.localizedDescription)")
                    } else {
                        print("Liked message successfully saved!")
                        likedMessages.append(likedMessage)
                    }
                }
            } catch {
                print("Error saving liked message: \(error.localizedDescription)")
            }
        }
    }

 
    
    func messageView(message: ChatMessage) -> some View {
        HStack {
            if message.sender == .me {
                Spacer()
                Text(message.content)
                    .font(Font.custom("Roboto", size: 18))
                    .foregroundColor(Color(UIColor(red: 54/255, green: 54/255, blue: 53/255, alpha: 1.0)))
                    .padding()
                    .background(Color(UIColor(red: 238/255, green: 234/255, blue: 228/255, alpha: 1.0)))
                    .cornerRadius(16)
                    .contextMenu {
                        Button(action: {
                            UIPasteboard.general.string = message.content
                        }) {
                            Label("Copy", systemImage: "doc.on.doc")
                        }
                        Button(action: {
                            deleteMessage(message)
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            } else if message.sender == .gpt {
                if !message.content.isEmpty {
                    if let url = URL(string: message.content),
                       let host = url.host,
                       host.contains("wa.me") {
                        Link(destination: url) {
                            Text(message.content)
                                .font(Font.custom("Roboto", size: 18))
                                .foregroundColor(.blue)
                                .padding()
                                .background(Color(UIColor(red: 218/255, green: 214/255, blue: 207/255, alpha: 1.0)))
                                .cornerRadius(16)
                                .contextMenu {
                                    Button(action: {
                                        UIPasteboard.general.string = message.content
                                    }) {
                                        Label("Copy", systemImage: "doc.on.doc")
                                    }
                                    Button(action: {
                                        deleteMessage(message) // Call the delete function for GPT messages
                                    }) {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    } else {
                        Text(message.content)
                            .font(Font.custom("Roboto", size: 18))
                            .foregroundColor(Color(UIColor(red: 54/255, green: 54/255, blue: 53/255, alpha: 1.0)))
                            .padding()
                            .background(Color(UIColor(red: 218/255, green: 214/255, blue: 207/255, alpha: 1.0)))
                            .cornerRadius(16)
                            .contextMenu {
                                Button(action: {
                                    UIPasteboard.general.string = message.content
                                }) {
                                    Label("Copy", systemImage: "doc.on.doc")
                                }
                                Button(action: {
                                    deleteMessage(message)
                                }) {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
                Spacer()
                Button(action: {
                    if !isMessageLiked(message) {
                        likeMessage(message)
                    } else {
                        showAlert = true
                    }
                }) {
                    Image(systemName: isMessageLiked(message) ? "heart.fill" : "heart")
                        .foregroundColor(isMessageLiked(message) ? .red : .gray)
                }
                .padding(.trailing, 8)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Already Liked"),
                          message: Text("You have already liked this message."),
                          dismissButton: .default(Text("OK")))
                }
            }
        }
    }

    func deleteMessage(_ message: ChatMessage) {
        chatMessages.removeAll { $0.id == message.id }
    }


    
    func sendMessage() {
        // Trim the message text to remove leading and trailing white spaces
        let trimmedMessageText = messageText.trimmingCharacters(in: .whitespacesAndNewlines)

        // Check if the message is empty after trimming
        guard !trimmedMessageText.isEmpty else {
            return
        }
        let userMessage = ChatMessage(id: UUID().uuidString, content: messageText, dateCreated: Date(), sender: .me)
            chatMessages.append(userMessage)
        
        let requestPayload: [String: String] = [
            "message": messageText
        ]
        
        AF.request("https://fastapi-oq6x.onrender.com/Chat", method: .post, parameters: requestPayload, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: [ChatResponse].self) { response in
                switch response.result {
                case .success(let chatResponses):
                    // Assuming the backend returns the phone number, booking text, and WhatsApp link
                    // in the same order they are sent, extract each response from the list.

                    if chatResponses.count >= 3 {
                        let phoneResponseMessage = ChatMessage(id: UUID().uuidString, content: chatResponses[0].response, dateCreated: Date(), sender: .gpt)
                        chatMessages.append(phoneResponseMessage)

                        let bookingResponseMessage = ChatMessage(id: UUID().uuidString, content: chatResponses[1].response, dateCreated: Date(), sender: .gpt)
                        chatMessages.append(bookingResponseMessage)

                        let whatsappResponseMessage = ChatMessage(id: UUID().uuidString, content: chatResponses[2].response, dateCreated: Date(), sender: .gpt)
                        chatMessages.append(whatsappResponseMessage)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        
        messageText = ""
    }
    
    func displayGreetingMessage() {
        let greeting1 = "Привет! Я бот для бронирования столиков в ресторанах и записей в салонах красоты."
        let greetingMessage1 = ChatMessage(id: UUID().uuidString, content: greeting1, dateCreated: Date(), sender: .gpt)
        chatMessages.append(greetingMessage1)
        
        let greeting2 = "Вы можете предоставить данные о бронировании, например, 'Название локации, дату, время, количество людей/название процедуры, и имя на брони'."
        let greetingMessage2 = ChatMessage(id: UUID().uuidString, content: greeting2, dateCreated: Date(), sender: .gpt)
        chatMessages.append(greetingMessage2)
    }

    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
    
    func isMessageLiked(_ message: ChatMessage) -> Bool {
        likedMessages.contains { $0.id == message.id }
    }
}

struct ChatMessage: Codable, Identifiable, Equatable {
    let id: String
    let content: String
    let dateCreated: Date
    let sender: MessageSender

    var senderString: String {
        switch sender {
        case .me:
            return "me"
        case .gpt:
            return "gpt"
        }
    }
}

enum MessageSender: String, Codable {
    case me
    case gpt
}

struct ChatResponse: Decodable {
    let response: String
}

extension ChatMessage {
    static let sampleMessages: [ChatMessage] = []
}


struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(showChat: .constant(false))
    }
}
