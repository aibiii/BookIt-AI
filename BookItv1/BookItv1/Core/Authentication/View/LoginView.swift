//
//  LoginView.swift
//  SwiftUIAuthentication
//
//  Created by Stephan Dowless on 2/23/23.
//

import SwiftUI

struct LoginView: View {
    @State var email = ""
    @State var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Image("logo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 120)
                        .padding(.vertical, 32)
                    
                    VStack(spacing: 24) {
                        InputView(text: $email,
                                  title: "Email",
                                  placeholder: "name@example.com")
                        .autocapitalization(.none)
                        
                        InputView(text: $password,
                                  title: "Пароль",
                                  placeholder: "Введите пароль",
                                  isSecureField: true)
                        .autocapitalization(.none)
                        
                        NavigationLink {
                            ResetPasswordView()
                                .navigationBarHidden(true)
                        } label: {
                            Text("Забыли пароль?")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Color(UIColor(red: 54/255, green: 54/255, blue: 53/255, alpha: 1.0)))
                            
                        }
                        .padding(.bottom)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                    
                    
                    Button {
                        Task {
                            try await viewModel.signIn(withEmail: email, password: password)
                        }
                    } label: {
                        HStack {
                            Text("Войти")
                                .fontWeight(.semibold)
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    }
                    .background(Color(UIColor(red: 54/255, green: 54/255, blue: 53/255, alpha: 1.0)))
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1 : 0.5)
                    .cornerRadius(10)
                    
                    Spacer()
                    
                    NavigationLink {
                        RegistrationView()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        HStack(spacing: 2) {
                            Text("Нет аккаунта?")
                            Text("Зарегестрироваться")
                                .fontWeight(.bold)
                        }
                        .font(.system(size: 14))
                        .foregroundColor(Color(UIColor(red: 54/255, green: 54/255, blue: 53/255, alpha: 1.0)))
                    }
                }
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Ошибка"),
                          message: Text(viewModel.authError?.description ?? ""))
                }
                
                if viewModel.isLoading {
                    CustomProgressView()
                }
            }
        }
        .onTapGesture {
                hideKeyboard()
            }
    }
    func hideKeyboard() {
            let resign = #selector(UIResponder.resignFirstResponder)
            UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
        }
}

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthViewModel())
    }
}

