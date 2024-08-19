//
//  joinsessionView.swift
//  Cloudkit_session
//
//  Created by Hans Zebua on 19/08/24.
//

import SwiftUI
import CloudKit

struct JoinSessionView: View {
    @StateObject private var joinCodeViewModel = CodeViewModel() // Separate instance for JoinSessionView
    @StateObject private var userStatusVM = checkUserStatusVM()

    @State private var inputCode: String = ""
    @State private var showError: Bool = false
    @State private var sessionLoaded: Bool = false

    var body: some View {
        VStack {
            TextField("Enter Code", text: $inputCode)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            Button("Join Session") {
                guard !inputCode.isEmpty else { return }
                
                joinCodeViewModel.fetchCode(byCode: inputCode) { found in
                    if found {
                        joinCodeViewModel.appendUserID(userStatusVM.userID?.recordName ?? "")
                        saveSessionData()
                    } else {
                        showError = true
                    }
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)

            if showError {
                Text("Code not found. Please try again.")
                    .foregroundColor(.red)
                    .padding()
            }

            if let codeModel = joinCodeViewModel.currentCode {
                VStack {
                    Text("Code: \(codeModel.code)")
                        .font(.headline)
                    Text("Created by: \(codeModel.creatorUsername)")
                        .font(.subheadline)
                    Text("Users: \(codeModel.users.joined(separator: ", "))")
                        .font(.subheadline)

                    Button(action: {
                        joinCodeViewModel.toggleIsClicked()
                    }) {
                        Text(codeModel.isClicked ? "Unclick" : "Click")
                            .padding()
                            .background(codeModel.isClicked ? Color.green : Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }

                    Button(action: {
                        joinCodeViewModel.removeUserID(userStatusVM.userID?.recordName ?? "")
                        clearSessionData()
                    }) {
                        Text("Leave Session")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
        }
        .padding()
        .onAppear {
            loadSessionData()
        }
    }

    private func saveSessionData() {
        if let codeModel = joinCodeViewModel.currentCode {
            UserDefaults.standard.set(codeModel.code, forKey: "savedCode")
        }
    }

    private func loadSessionData() {
        if let savedCode = UserDefaults.standard.string(forKey: "savedCode"), !sessionLoaded {
            joinCodeViewModel.fetchCode(byCode: savedCode) { found in
                sessionLoaded = true
                if found {
                    showError = false
                } else {
                    showError = true
                    clearSessionData()
                }
            }
        }
    }

    private func clearSessionData() {
        UserDefaults.standard.removeObject(forKey: "savedCode")
    }
}

#Preview {
    JoinSessionView()
}






