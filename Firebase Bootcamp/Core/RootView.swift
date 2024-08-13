//
//  RootView.swift
//  Firebase Bootcamp
//
//  Created by Parth Antala on 8/11/24.
//

import SwiftUI

struct RootView: View {
    @State private var showSignInView = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                ProfileView(showSignInView: $showSignInView)
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        
        }
           
    }
}

#Preview {
    RootView()
}
