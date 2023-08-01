//
//  RegistrationView.swift
//  SwiftUIAuthentication
//
//  Created by Stephan Dowless on 2/23/23.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var fullname = ""
    @State private var confirmPassword = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
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
                    
                    InputView(text: $fullname,
                              title: "Имя и Фамилия",
                              placeholder: "Введите имя и фамилию")
                    
                    InputView(text: $phone,
                              title: "Номер телефона",
                              placeholder: "Введите WhatsApp номер")
                    
                    InputView(text: $password,
                              title: "Пароль",
                              placeholder: "Введите пароль",
                              isSecureField: true)
                    .autocapitalization(.none)
                    
                    ZStack(alignment: .trailing) {
                        InputView(text: $confirmPassword,
                                  title: "Подтвердите пароль",
                                  placeholder: "Подтвердите пароль",
                                  isSecureField: true)
                        .autocapitalization(.none)
                        
                        if !password.isEmpty && !confirmPassword.isEmpty {
                            if password == confirmPassword {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemGreen))
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemRed))
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                
                Button {
                    Task {
                        try await viewModel.createUser(withEmail: email,
                                                       password: password,
                                                       fullname: fullname,
                        phone: phone)
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
                .opacity(formIsValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top)
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 2) {
                        Text("Уже есть аккаунт?")
                        Text("Войти")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                    .foregroundColor(Color(UIColor(red: 54/255, green: 54/255, blue: 53/255, alpha: 1.0)))
                }
            }
            
            if viewModel.isLoading {
                CustomProgressView()
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Ошибка"),
                  message: Text(viewModel.authError?.description ?? ""))
        }
    }
}

// MARK: - AuthenticationFormProtocol

extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && !fullname.isEmpty
        && password == confirmPassword
        && password.count > 5
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
            .environmentObject(AuthViewModel())
    }
}
