//
//  AuthenticationView.swift
//  Stories
//
//  Created by Parth Antala on 8/11/24.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

import AuthenticationServices

struct signInWithAppleButtonViewRepresentable: UIViewRepresentable {
    let type: ASAuthorizationAppleIDButton.ButtonType
    let style: ASAuthorizationAppleIDButton.Style
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton(type: type, style: style)
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        
    }
    
    
}




@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let _ = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        
        
    }
    
    func signInApple() async throws {
        
    }
}
struct AuthenticationView: View {
    @Binding var showSignInView: Bool
    @StateObject var viewModel = AuthenticationViewModel()
    var body: some View {
        VStack {
            NavigationLink {
                SignInWithEmailView(showSignInView: $showSignInView, newUser: true)
            } label: {
                Text("Sign Up")
            }
            
            NavigationLink {
                SignInWithEmailView(showSignInView: $showSignInView, newUser: false)
            } label: {
                Text("Sign In")
            }
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                Task {
                    do {
                        try await viewModel.signInGoogle()
                        showSignInView = false
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            Button {
                Task {
                    do {
                        try await viewModel.signInApple()
                        showSignInView = false
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            } label: {
                signInWithAppleButtonViewRepresentable(type: .continue, style: .black)
                    .allowsHitTesting(false)
            }
            .frame(height: 55)
            
        }
        .navigationTitle("Sign In")
    }
}

#Preview {
    AuthenticationView(showSignInView: .constant(false))
}
