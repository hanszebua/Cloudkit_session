//
//  homepage.swift
//  Cloudkit_session
//
//  Created by Hans Zebua on 19/08/24.
//

import SwiftUI

struct MainView: View {
    @StateObject private var codeViewModel = CodeViewModel() // Initialize here

    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome")
                    .font(.largeTitle)
                    .padding()

                NavigationLink(destination: CreateSessionView()
                                .environmentObject(codeViewModel)) { // Pass down environment object
                    Text("Create Session")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()

                NavigationLink(destination: JoinSessionView()
                                .environmentObject(codeViewModel)) { // Pass down environment object
                    Text("Join Session")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
            .padding()
        }
    }
}

#Preview {
    MainView()
}


