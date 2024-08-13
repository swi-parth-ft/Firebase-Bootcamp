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
    
    @MainActor
    func togglePremiumStatus() {
        guard let user else { return }
        let currenStatus = user.isPremeum ?? false
        Task {
            try await UserManager.shared.updateUserPremiumStatus(userId: user.userId, isPremium: !currenStatus)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    @MainActor
    func addUserPreference(text: String) {
        guard let user else { return }
        
        Task {
            try await UserManager.shared.addUserPreference(userId: user.userId, preference: text)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    @MainActor
    func removeUserPreference(text: String) {
        guard let user else { return }
        
        Task {
            try await UserManager.shared.removeUserPreference(userId: user.userId, preference: text)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    @MainActor
    func addFavoriteMovie() {
        guard let user else { return }
        let movie = Movie(id: "1", title: "Avatar 2", isPopular: true)
        Task {
            try await UserManager.shared.addFavoriteMovie(userId: user.userId, movie: movie)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    @MainActor
    func removeFavoriteMovie() {
        guard let user else { return }

        Task {
            try await UserManager.shared.removeFavoriteMovie(userId: user.userId)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
}
struct ProfileView: View {
    @Binding var showSignInView: Bool
    @StateObject private var viewModel = ProfileViewModel()
    let preferenceOptions: [String] = ["Sports", "Movies", "Books"]
    
    private func preferenceIsSelected(text: String) -> Bool {
        print(viewModel.user?.preferences ?? "n/a")
        return viewModel.user?.preferences?.contains(text) == true
        
    }
    
    var body: some View {
        List {
            if let user = viewModel.user {
                Text(user.userId)
                Text(user.email ?? "N/A")
                
                
                Button {
                    viewModel.togglePremiumStatus()
                } label: {
                    Text("is Premium: \((user.isPremeum ?? false).description.capitalized)")
                }
                
                VStack {
                    HStack {
                        ForEach(preferenceOptions, id: \.self) { string in
                            Button(string) {
                                if preferenceIsSelected(text: string) {
                                    viewModel.removeUserPreference(text: string)
                                } else {
                                    viewModel.addUserPreference(text: string)
                                }
                            }
                            .font(.headline)
                            .buttonStyle(.borderedProminent)
                            .tint(preferenceIsSelected(text: string) ? .green : .red)
                        }
                    }
                    
                    Text("User preferences: \((user.preferences ?? []).joined(separator: ", "))")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Button {
                    if user.favMovie == nil {
                        viewModel.addFavoriteMovie()
                    } else {
                        viewModel.removeFavoriteMovie()
                    }
                } label: {
                    Text("Favorite Movie: \((user.favMovie?.title ?? ""))")
                }
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
