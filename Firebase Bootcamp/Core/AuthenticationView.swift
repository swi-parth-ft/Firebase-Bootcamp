//
//  AuthenticationView.swift
//  Stories
//
//  Created by Parth Antala on 8/11/24.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    @Published var didSignInWithApple = false
    let signInAppleHelper = SignInAppleHelper()
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        let user = UserModel(userId: authDataResult.uid, createdAt: Date(), email: authDataResult.email, photoURL: authDataResult.photoURL)
        try await UserManager.shared.createNewUser(user: user)
       
        
        
    }
    func signInApple() async throws {
        signInAppleHelper.startSignInWithAppleFlow { result in
            switch result {
            case .success(let signInAppleResult):
                Task {
                    do {
                        let _ = try await AuthenticationManager.shared.signInWithApple(tokens: signInAppleResult)
                        self.didSignInWithApple = true
                    } catch {
                        
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            } label: {
                signInWithAppleButtonViewRepresentable(type: .continue, style: .black)
                    .allowsHitTesting(false)
            }
            .frame(height: 55)
            .onChange(of: viewModel.didSignInWithApple) { oldValue, newValue in
                if newValue {
                    showSignInView = false
                }
            }
            
        }
        .navigationTitle("Sign In")
    }
}

#Preview {
    AuthenticationView(showSignInView: .constant(false))
}
