import SwiftUI

struct CreateSessionView: View {
    @EnvironmentObject var vm: CodeViewModel
    @StateObject private var userStatusVM = checkUserStatusVM()
    
    @State private var inputCode: String = ""
    
    var body: some View {
        VStack {
            TextField("Enter Code", text: $inputCode)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            
            Button("Submit") {
                guard let creatorID = userStatusVM.userID?.recordName else {
                    print("User ID not available")
                    return
                }
                vm.addCode(newCode: inputCode, creatorUsername: userStatusVM.userName.description, creatorID: creatorID)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            if let codeModel = vm.currentCode {
                VStack {
                    Text("Code: \(codeModel.code)")
                        .font(.headline)
                    Text("Created by: \(codeModel.creatorUsername)")
                        .font(.subheadline)
                    Text("Users: \(codeModel.users.joined(separator: ", "))")
                        .font(.subheadline)
                    Text("Clicked: \(codeModel.isClicked ? "Yes" : "No")")
                        .font(.subheadline)
                    
                    Button("Toggle Clicked Status") {
                        vm.toggleIsClicked()
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Button("Delete Code") {
                        vm.deleteCurrentCode()
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
            } else {
                Text("No Code Found")
                    .padding()
            }
        }
        .padding()
        .onAppear {
            vm.fetchCode(byCode: "SPECIFIC_CODE_TO_FETCH") // Replace with the actual code to fetch
        }
    }
}

#Preview {
    CreateSessionView()
        .environmentObject(CodeViewModel()) // Preview needs environment object
}


