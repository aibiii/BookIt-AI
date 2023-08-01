//
//  AnimationLater.swift
//  BookItv1
//
//  Created by Aibibi Kuan on 26.07.2023.
//

import Foundation
import SwiftUI

struct AnimatedTypewritingBotMessageView: View {
    let message: ChatMessage
    let likedMessages: [LikedMessage]
    let isMessageLiked: (ChatMessage) -> Bool

    @State private var displayText: String = ""
    @State private var isTypingAnimated: Bool = false

    var body: some View {
        TypewritingBotMessageView(
            message: message.content,
            likedMessages: likedMessages,
            isMessageLiked: isMessageLiked,
            ignoreAnimation: !isTypingAnimated // Ignore animation when isTypingAnimated is false
        )
        .onAppear {
            if !isTypingAnimated {
                startTypewritingAnimation()
                isTypingAnimated = true
            }
        }
    }

    private func startTypewritingAnimation() {
        displayText = "" // Reset the displayText before starting the animation
        animateTyping(message: message.content)
    }

    private func animateTyping(message: String) {
        guard !message.isEmpty else { return }
        var index = message.startIndex
        let lastIndex = message.index(before: message.endIndex)
        while index <= lastIndex {
            let currentCharacter = message[index]
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index.utf16Offset(in: message)) * 0.03) {
                displayText.append(currentCharacter)
            }
            message.formIndex(after: &index)
        }
    }
}


struct TypewritingBotMessageView: View {
    let message: String
    let likedMessages: [LikedMessage]
    let isMessageLiked: (ChatMessage) -> Bool
    let ignoreAnimation: Bool
    
    @State private var displayText: String = ""
    @State private var isTypingAnimated: Bool = false // Track if animation has started

    init(message: String, likedMessages: [LikedMessage], isMessageLiked: @escaping (ChatMessage) -> Bool, ignoreAnimation: Bool) {
        self.message = message
        self.likedMessages = likedMessages
        self.isMessageLiked = isMessageLiked
        self.ignoreAnimation = ignoreAnimation
    }

    var body: some View {
        HStack {
            Text(displayText)
                .font(Font.custom("Urbanist", size: 18))
                .foregroundColor(Color(UIColor(red: 54/255, green: 54/255, blue: 53/255, alpha: 1.0)))
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(Color(UIColor(red: 218/255, green: 214/255, blue: 207/255, alpha: 1.0)))
                )
                .cornerRadius(16)
                .onAppear {
                    if !isTypingAnimated { // Check if animation hasn't started
                        startTypewritingAnimation()
                        isTypingAnimated = true // Set the flag to true once animation starts
                    }
                }
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func startTypewritingAnimation() {
        displayText = "" // Reset the displayText before starting the animation
        animateTyping(message: message)
    }

    private func animateTyping(message: String) {
        guard !message.isEmpty else { return }
        var index = message.startIndex
        let lastIndex = message.index(before: message.endIndex)
        while index <= lastIndex {
            let currentCharacter = message[index]
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index.utf16Offset(in: message)) * 0.03) {
                displayText.append(currentCharacter)
            }
            message.formIndex(after: &index)
        }
    }
}
