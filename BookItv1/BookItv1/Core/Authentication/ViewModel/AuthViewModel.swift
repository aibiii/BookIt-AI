//
//  AuthViewModel.swift
//  SwiftUIAuthentication
//
//  Created by Stephan Dowless on 2/23/23.
//

import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var authError: AuthError?
    @Published var showAlert = false
    @Published var isLoading = false
    
    init() {
        userSession = Auth.auth().currentUser
        
        Task {
            isLoading = true
            await fetchUser()
            isLoading = false
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        isLoading = true
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
            isLoading = false
        } catch {
            let authError = AuthErrorCode.Code(rawValue: (error as NSError).code)
            self.showAlert = true
            self.authError = AuthError(authErrorCode: authError ?? .userNotFound)
            isLoading = false
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String, phone: String) async throws {
        isLoading = true
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email, phone: phone)
            guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
            try await Firestore.firestore().collection("users").document(result.user.uid).setData(encodedUser)
            await fetchUser()
            isLoading = false
        } catch {
            let authError = AuthErrorCode.Code(rawValue: (error as NSError).code)
            self.showAlert = true
            self.authError = AuthError(authErrorCode: authError ?? .userNotFound)
            isLoading = false 
        }
    }
    
    func signout() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil 
            self.currentUser = nil
        } catch {
            print("DEBUG: Failed to sign out with error: \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() async throws {
        do {
            try await Auth.auth().currentUser?.delete()
            deleteUserData()
            self.currentUser = nil
            self.userSession = nil
        } catch {
            print("DEBUG: Failed to delete account with error \(error.localizedDescription)")
        }
    }
    
    func sendResetPasswordLink(toEmail email: String) {
        Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument()
        guard let user = try? snapshot?.data(as: User.self) else { return }
        self.currentUser = user
    }
    
    func deleteUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).delete()
    }
}
