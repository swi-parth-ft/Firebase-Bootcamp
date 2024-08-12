//
//  AuthenticationView.swift
//  Stories
//
//  Created by Parth Antala on 8/11/24.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth


struct googleSignInResultModel {
    let idToken: String
    let accessToken: String
}
@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    
    func signInGoogle() async throws {
        guard let topVC = Utilities.shared.topViewController() else { throw URLError(.cannotFindHost) }
        
        
        let gidSignInResults = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        guard let idToken = gidSignInResults.user.idToken?.tokenString else { throw URLError(.badURL) }
        let accessToken = gidSignInResults.user.accessToken.tokenString 
        
        let tokens = googleSignInResultModel(idToken: idToken, accessToken: accessToken)
        let _ = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        
        
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
            
        }
        .navigationTitle("Sign In")
    }
}

#Preview {
    AuthenticationView(showSignInView: .constant(false))
}
