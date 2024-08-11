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
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView(showSignInView: .constant(false))
}
