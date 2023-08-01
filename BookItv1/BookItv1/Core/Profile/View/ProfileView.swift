import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isScrollingDown = false
    @State private var isShowingHowToView = false
    
    var body: some View {
        ZStack {
            Color(red: 0.9333333333333333, green: 0.9176470588235294, blue: 0.8941176470588236)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Profile")
                    .font(Font.custom("Roboto-Bold", size: 40))
                    .fontWeight(.bold)
                    .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
                    .foregroundColor(Color(red: 0.21176470588235294, green: 0.21176470588235294, blue: 0.20784313725490197))
                    .padding(.top, 25)
                    .padding(.bottom, 5)

                if let user = viewModel.currentUser {
                    ScrollView {
                        VStack {
                            HStack {
                                Text(user.initials)
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(width: 72, height: 72)
                                    .background(Color(UIColor(red: 54/255, green: 54/255, blue: 53/255, alpha: 1.0)))
                                    .clipShape(Circle())

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(user.fullname)
                                        .fontWeight(.semibold)
                                        .padding(.top, 4)

                                    Text(user.email)
                                        .font(.footnote)
                                        .accentColor(.gray)
                                }

                                Spacer()
                            }
                            .padding()

                            VStack(alignment: .leading, spacing: 16) {
                                VStack(spacing: 16) {
                                    Text("Общее").font(.custom("Roboto-Bold", size: 20))
                                    HStack {
                                        SettingsRowView(imageName: "gear", title: "Версия", backgroundColor: Color(UIColor(red: 54/255, green: 54/255, blue: 53/255, alpha: 1.0)), iconColor: .white)
                                            .frame(maxWidth: .infinity)
                                        Spacer()
                                        Text("1.0.0")
                                            .font(.custom("Roboto-Regular", size: 14))
                                            .foregroundColor(.black)
                                    }

                                    SettingsRowView(imageName: "hand.raised.fill", title: "Приватность", backgroundColor: Color(UIColor(red: 54/255, green: 54/255, blue: 53/255, alpha: 1.0)), iconColor: .white)
                                        .frame(maxWidth: .infinity)
                                    
                                    HStack {
                                        SettingsRowView(imageName: "questionmark.circle.fill", title: "Поддержка", backgroundColor: Color(UIColor(red: 54/255, green: 54/255, blue: 53/255, alpha: 1.0)), iconColor: .white)
                                        Spacer()
                                        
                                        Button(action: {
                                            isShowingHowToView = true
                                        }) {
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.white)
                                                .padding(.vertical, 10)
                                                .padding(.horizontal, 16)
                                                .background(RoundedRectangle(cornerRadius: 12).fill(Color(UIColor(red: 54/255, green: 54/255, blue: 53/255, alpha: 1.0))))
                                        }
                                        .fullScreenCover(isPresented: $isShowingHowToView, content: {
                                            HowToView()
                                                .navigationBarTitle("Поддержка")
                                        })
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))

                                VStack(spacing: 16) {
                                    Text("Дополнительное").font(.headline)
                                    HStack {
                                        SettingsRowView(imageName: "heart.fill", title: "Help the dev!", backgroundColor: Color(.systemRed), iconColor: .white)
                                        Spacer()
                                        Text("Coming soon...")
                                            .font(.custom("Roboto-Regular", size: 14))
                                            .foregroundColor(.gray)
                                    }
                                    

                                    HStack {
                                        SettingsRowView(imageName: "square.and.arrow.up.fill", title: "Поделиться приложением", backgroundColor: Color(UIColor(red: 54/255, green: 54/255, blue: 53/255, alpha: 1.0)), iconColor: .white)
                                        Spacer()
                                        Text("Coming soon...")
                                            .font(.custom("Roboto-Regular", size: 14))
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))

                                VStack(spacing: 16) {
                                    Text("Аккаунт").font(.headline)
                                    Button {
                                        viewModel.signout()
                                    } label: {
                                        SettingsRowView(imageName: "arrow.left.circle.fill", title: "Выйти", backgroundColor: Color(.systemRed), iconColor: .white)                                    }
                                    
                                    Button {
                                        Task {
                                            try await viewModel.deleteAccount()
                                        }
                                    } label: {
                                        SettingsRowView(imageName: "xmark.circle.fill", title: "Удалить аккаунт", backgroundColor: Color(.systemRed), iconColor: .white)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom, 50)
                    }
                }
            }

            if viewModel.isLoading {
                CustomProgressView()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthViewModel())
    }
}
