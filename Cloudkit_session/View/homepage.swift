//
//  homepage.swift
//  Cloudkit_session
//
//  Created by Hans Zebua on 19/08/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome")
                    .font(.largeTitle)
                    .padding()

                NavigationLink(destination: CreateSessionView()) {
                    Text("Create Session")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()

                NavigationLink(destination: JoinSessionView()) {
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
