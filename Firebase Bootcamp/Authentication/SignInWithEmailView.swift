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
    
    func SignIn() {
        guard !email.isEmpty, !password.isEmpty else {
            print("no email or password found!")
            return
        }
        Task{
            do {
                let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
                print(returnedUserData)
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
}

struct SignInWithEmailView: View {
    
    @StateObject private var viewModel = SignInEmailViewModel()
    var body: some View {
        VStack {
            TextField("Email..", text: $viewModel.email)
            TextField("Password..", text: $viewModel.password)
            Button {
                viewModel.SignIn()
            } label: {
                Text("Sign in")
            }
        }
    }
}

#Preview {
    SignInWithEmailView()
}
