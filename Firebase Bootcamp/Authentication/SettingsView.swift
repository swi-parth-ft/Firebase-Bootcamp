//
//  SettingsView.swift
//  Firebase Bootcamp
//
//  Created by Parth Antala on 8/11/24.
//

import SwiftUI

final class SettingViewModel: ObservableObject {
    func logOut() throws {
        try AuthenticationManager.shared.SignOut()
    }
    
    func resetPassword() async throws {
        let user = try AuthenticationManager.shared.getAuthenticatedUser()
        guard let email = user.email else {
            throw URLError(.fileIsDirectory)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws {
        let email = "hello123@gmail.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws {
        let password = "hello12345"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
}
struct SettingsView: View {
    
    @StateObject private var viewModel = SettingViewModel()
    @Binding var showSignInView: Bool
    var body: some View {
        List {
            Button("Log out") {
                Task {
                    do {
                        try viewModel.logOut()
                        showSignInView = true
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            
            Button("Password reset") {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("Pasword reset")
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            
            Button("Password update") {
                Task {
                    do {
                        try await viewModel.updatePassword()
                        print("Pasword updated")
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            
            Button("update email") {
                Task {
                    do {
                        try await viewModel.updateEmail()
                        print("email updated")
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView(showSignInView: .constant(false))
}
