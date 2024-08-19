//
//  joinsessionView.swift
//  Cloudkit_session
//
//  Created by Hans Zebua on 19/08/24.
//

import SwiftUI
import CloudKit

struct JoinSessionView: View {
    @StateObject private var codeViewModel = CodeViewModel()
    @StateObject private var userStatusVM = checkUserStatusVM() // Initialize checkUserStatusVM

    @State private var inputCode: String = ""
    @State private var showError: Bool = false

    var body: some View {
        VStack {
            TextField("Enter Code", text: $inputCode)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            
            Button("Join Session") {
                codeViewModel.fetchCode(byCode: inputCode) { found in
                    if found {
                        // Append user ID to the session
                        codeViewModel.appendUserID(userStatusVM.userID?.recordName ?? "")
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
            
            if let codeModel = codeViewModel.currentCode {
                VStack {
                    Text("Code: \(codeModel.code)")
                        .font(.headline)
                    Text("Created by: \(codeModel.creatorUsername)")
                        .font(.subheadline)
                    Text("Users: \(codeModel.users.joined(separator: ", "))")
                        .font(.subheadline)
                    
                    Button(action: {
                        codeViewModel.toggleIsClicked()
                    }) {
                        Text(codeModel.isClicked ? "Unclick" : "Click")
                            .padding()
                            .background(codeModel.isClicked ? Color.green : Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
        }
        .padding()
    }
}

#Preview {
    JoinSessionView()
}

