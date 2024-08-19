import SwiftUI

struct CodeInputView: View {
    @StateObject private var vm = CodeViewModel()
    
    @State private var inputCode: String = ""
    @State private var inputUsername: String = ""
    
    var body: some View {
        VStack {
            TextField("Enter Code", text: $inputCode)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            
            TextField("Enter Your Username", text: $inputUsername)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            
            Button("Submit") {
                let creatorID = UUID().uuidString // Assuming you generate a unique ID for each user
                vm.addCode(newCode: inputCode, creatorUsername: inputUsername, creatorID: creatorID)
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
    CodeInputView()
}
