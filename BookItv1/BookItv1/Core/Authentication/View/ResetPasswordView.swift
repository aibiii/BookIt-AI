//
//  RegistrationView.swift
//  SwiftUIAuthentication
//
//  Created by Stephan Dowless on 2/23/23.
//

import SwiftUI

struct ResetPasswordView: View {
    @State private var email = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 140)
                .padding(.vertical, 32)
            
            
            InputView(text: $email,
                      title: "Email",
                      placeholder: "Enter the email associated with your account")
            .padding()
            
            Button {
                viewModel.sendResetPasswordLink(toEmail: email)
                dismiss()
            } label: {
                HStack {
                    Text("SEND RESET LINK")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 50)
            }
            .background(Color(UIColor(red: 54/255, green: 54/255, blue: 53/255, alpha: 1.0)))
            .cornerRadius(10)
            .padding()
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                HStack {
                    Image(systemName: "arrow.left")
                        .foregroundColor(Color(UIColor(red: 54/255, green: 54/255, blue: 53/255, alpha: 1.0)))
                    
                    Text("Back to Login")
                        .fontWeight(.semibold)
                        .foregroundColor(Color(UIColor(red: 54/255, green: 54/255, blue: 53/255, alpha: 1.0)))
                }
            }
        }
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
