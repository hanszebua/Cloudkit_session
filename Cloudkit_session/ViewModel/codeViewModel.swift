import Foundation
import CloudKit

struct CodeModel: Identifiable, Hashable {
    let id = UUID()
    var code: String
    var creatorUsername: String
    var creatorID: String
    var users: [String] // List of user IDs associated with the code
    var record: CKRecord
}

class CodeViewModel: ObservableObject {
    @Published var code: String = ""
    @Published var creatorUsername: String = ""
    @Published var currentCode: CodeModel?
    
    init() {
        // Fetch the specific code if needed
    }
    
    func addCode(newCode: String, creatorUsername: String, creatorID: String) {
        let newCodeRecord = CKRecord(recordType: "Codes")
        newCodeRecord["code"] = newCode
        newCodeRecord["creatorUsername"] = creatorUsername
        newCodeRecord["creatorID"] = creatorID
        newCodeRecord["users"] = [creatorID] // Initialize with the creator's ID
        
        saveCode(record: newCodeRecord)
    }
    
    private func saveCode(record: CKRecord) {
        CKContainer.default().publicCloudDatabase.save(record) { [weak self] returnedRecord, returnedError in
            DispatchQueue.main.async {
                if let savedRecord = returnedRecord {
                    let code = savedRecord["code"] as? String ?? ""
                    let creatorUsername = savedRecord["creatorUsername"] as? String ?? ""
                    let creatorID = savedRecord["creatorID"] as? String ?? ""
                    let users = savedRecord["users"] as? [String] ?? []
                    
                    self?.currentCode = CodeModel(code: code, creatorUsername: creatorUsername, creatorID: creatorID, users: users, record: savedRecord)
                }
            }
        }
    }
    
    func fetchCode(byCode code: String) {
        let predicate = NSPredicate(format: "code == %@", code)
        let query = CKQuery(recordType: "Codes", predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        
        queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
            switch returnedResult {
            case .success(let record):
                guard let code = record["code"] as? String,
                      let creatorUsername = record["creatorUsername"] as? String,
                      let creatorID = record["creatorID"] as? String,
                      let users = record["users"] as? [String] else { return }
                
                DispatchQueue.main.async {
                    self.currentCode = CodeModel(code: code, creatorUsername: creatorUsername, creatorID: creatorID, users: users, record: record)
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
        addOperation(operation: queryOperation)
    }
    
    func addOperation(operation: CKDatabaseOperation) {
        CKContainer.default().publicCloudDatabase.add(operation)
    }
}






