//
//  SignInWithEmailView.swift
//  Stories
//
//  Created by Parth Antala on 8/11/24.
//

import SwiftUI
import Firebase

@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func SignUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("no email or password found!")
            return
        }
  
        let _ = try await AuthenticationManager.shared.createUser(email: email, password: password)
    }
    
    func SignIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("no email or password found!")
            return
        }
        let _ = try await AuthenticationManager.shared.signIn(email: email, password: password)
          
    }
}

struct SignInWithEmailView: View {
    
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    
    var newUser: Bool
    
    var body: some View {
        VStack {
            Text(newUser ? "Signing Up" : "Signing In")
            TextField("Email..", text: $viewModel.email)
            TextField("Password..", text: $viewModel.password)
            Button {
                if newUser {
                    Task {
                        do {
                            try await viewModel.SignUp()
                            showSignInView = false
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    
                } else {
                    Task {
                        do {
                            try await viewModel.SignIn()
                            showSignInView = false
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            } label: {
                Text("Sign in")
            }
        }
    }
}

#Preview {
    SignInWithEmailView(showSignInView: .constant(false), newUser: true)
}
