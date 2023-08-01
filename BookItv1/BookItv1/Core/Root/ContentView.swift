import SwiftUI

struct ContentView: View {
    @State private var showChat = false
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                authorizedTabView
            } else {
                LoginView()
            }
        }
        .fullScreenCover(isPresented: $showChat, onDismiss: {
            // Handle dismissal action here if needed
        }) {
            ChatView(showChat: $showChat)
        }
    }
    
    @ViewBuilder
    private var authorizedTabView: some View {
        NavigationView {
            ZStack {
                Color.white
                TabView {
                    HomeView(showChat: $showChat)
                        .tabItem {
                            Image(systemName: "house")
                            Text("Home")
                        }
                    
                    HistoryView()
                        .tabItem {
                            Image(systemName: "heart.fill")
                            Text("Saved")
                        }
                    
                    ProfileView()
                        .tabItem {
                            Image(systemName: "person")
                            Text("Profile")
                        }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
    }
}

