//
//  AuthenticationView.swift
//  Stories
//
//  Created by Parth Antala on 8/11/24.
//

import SwiftUI

struct AuthenticationView: View {
    @Binding var showSignInView: Bool
    
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
            
        }
        .navigationTitle("Sign In")
    }
}

#Preview {
    AuthenticationView(showSignInView: .constant(false))
}
