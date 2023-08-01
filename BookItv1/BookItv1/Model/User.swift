//
//  User.swift
//  SwiftUIAuthentication
//
//  Created by Stephan Dowless on 2/23/23.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String
    let phone: String
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
             formatter.style = .abbreviated
             return formatter.string(from: components)
        }
        
        return ""
    }
}

extension User {
    static var MOCK_USER = User(
        id: NSUUID().uuidString,
        fullname: "Stephan Dowless",
        email: "dowless.stephan@gmail.com",
        phone: "+77071117711"
    )
}
