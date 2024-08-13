//
//  ProfileView.swift
//  Firebase Bootcamp
//
//  Created by Parth Antala on 8/13/24.
//

import SwiftUI

final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: UserModel? = nil
    
    @MainActor
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
        print("this is \(String(describing: user))")
    }
    
}
struct ProfileView: View {
    @Binding var showSignInView: Bool
    @StateObject private var viewModel = ProfileViewModel()
    var body: some View {
        List {
            if let user = viewModel.user {
                Text(user.userId)
                Text(user.email ?? "N/A")
            }
            
        }
        .onAppear {
            Task {
                try? await viewModel.loadCurrentUser()
            }
        }
        .navigationTitle("Profile")
            .toolbar {
                NavigationLink(destination: SettingsView(showSignInView: $showSignInView)) {
                    Button("", systemImage: "gear") {
                        
                    }
                }
            }
    }
}

#Preview {
    ProfileView(showSignInView: .constant(false))
}
