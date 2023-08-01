//
//  InputView.swift
//  SwiftUIAuthentication
//
//  Created by Stephan Dowless on 2/23/23.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(Color(.systemGray))
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .keyboardType(.default) // Set to .default for secure fields
            } else if title == "Номер телефона" {
                TextField(placeholder, text: $text)
                    .keyboardType(.decimalPad) // Set to .numberPad for phone input
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(.default)
            }
            Divider()
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(text: .constant(""), title: "Email", placeholder: "name@example.com")
    }
}
