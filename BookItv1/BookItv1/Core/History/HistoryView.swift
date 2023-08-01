import SwiftUI
import Firebase

struct HistoryView: View {
    @State private var likedMessages: [LikedMessage] = []
    
    private var groupedLikedMessages: [String: [LikedMessage]] {
        Dictionary(grouping: likedMessages, by: { dateFormatter.string(from: $0.dateLiked) })
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    private var userID: String? {
        return Auth.auth().currentUser?.uid
    }

    var body: some View {
            VStack {
                Text("Liked Messages")
                    .font(Font.custom("Roboto", size: 40))
                    .fontWeight(.bold)
                    .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
                    .foregroundColor(Color(red: 0.21176470588235294, green: 0.21176470588235294, blue: 0.20784313725490197))
                    .padding(.top, 25)
                    .padding(.bottom, 5)

                if likedMessages.isEmpty {
                    // Show a view with the desired background color when likedMessages is empty
                    Color(red: 0.9333333333333333, green: 0.9176470588235294, blue: 0.8941176470588236)
                        .edgesIgnoringSafeArea(.all)
                } else {
                    List {
                        ForEach(groupedLikedMessages.sorted(by: { $0.key > $1.key }), id: \.key) { date, messages in
                            Section(header: Text(date).font(.headline)) {
                                ForEach(messages) { likedMessage in
                                    HStack {
                                        // Check if the message is a link
                                        if let url = URL(string: likedMessage.content), UIApplication.shared.canOpenURL(url) {
                                            Link(likedMessage.content, destination: url)
                                                .foregroundColor(.blue) // Change link color to blue
                                        } else {
                                            Text(likedMessage.content)
                                                .onLongPressGesture {
                                                    showCopyAlert(message: likedMessage.content)
                                                }
                                        }
                                        Spacer()
                                    }
                                    .padding()
                                    .swipeActions {
                                        Button(action: {
                                            deleteLikedMessage(likedMessage)
                                        }) {
                                            Text("Delete")
                                        }
                                        .tint(.red)
                                    }
                                }
                                .textCase(nil)
                                .padding(.vertical, 2)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .background(Color(red: 0.9333333333333333, green: 0.9176470588235294, blue: 0.8941176470588236))
            .onAppear {
                loadLikedMessages()
            }
        }

    private func showCopyAlert(message: String) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = message
        
        let alert = UIAlertController(title: "Message Copied", message: "The message has been copied to the clipboard.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        if let viewController = UIApplication.shared.windows.first?.rootViewController {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    private func loadLikedMessages() {
        guard let userID = userID else {
            return
        }

        Firestore.firestore().collection("users").document(userID).collection("likedMessages").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching liked messages: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            likedMessages = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: LikedMessage.self)
            }
        }
    }

    private func deleteLikedMessage(_ likedMessage: LikedMessage) {
        guard let userID = userID else {
            return
        }

        let documentID = likedMessage.id
        
        Firestore.firestore().collection("users").document(userID).collection("likedMessages").document(documentID).delete { error in
            if let error = error {
                print("Error deleting liked message from Firestore: \(error.localizedDescription)")
            } else {
                // If the Firestore deletion is successful, update the local array
                likedMessages.removeAll { $0.id == likedMessage.id }
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
