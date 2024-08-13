//
//  SettingsView.swift
//  Firebase Bootcamp
//
//  Created by Parth Antala on 8/11/24.
//

import SwiftUI
import FirebaseVertexAI

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
    
    func deleteAccount() async throws {
        try await AuthenticationManager.shared.delete()
    }
}
struct SettingsView: View {
    
    @StateObject private var viewModel = SettingViewModel()
    @Binding var showSignInView: Bool
    
    let vertex = VertexAI.vertexAI()

    // Initialize the generative model with a model that supports your use case
    // Gemini 1.5 models are versatile and can be used with all API capabilities
    
    
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
            
            Button(role: .destructive) {
                Task {
                    do {
                        try await viewModel.deleteAccount()
                        showSignInView = true
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            } label: {
                Text("Delete account")
            }
            
            Button("Generate") {
                Task {
                    do {
                        try await generate()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                
            }

        }
        .navigationTitle("Settings")
    }
    
    func generate() async throws {
        let prompt = "Write a story about a magic backpack."
        let model = vertex.generativeModel(modelName: "gemini-1.5-flash")
        // To generate text output, call generateContent with the text input
        let response = try await model.generateContent(prompt)
        if let text = response.text {
          print(text)
        }
    }
}

#Preview {
    SettingsView(showSignInView: .constant(false))
}
