//
//  AuthenticationView.swift
//  Stories
//
//  Created by Parth Antala on 8/11/24.
//

import SwiftUI

struct AuthenticationView: View {
    var body: some View {
        VStack {
            NavigationLink {
                SignInWithEmailView()
            } label: {
                Text("sign in with email")
            }
        }
        .navigationTitle("Sign In")
    }
}

#Preview {
    AuthenticationView()
}
