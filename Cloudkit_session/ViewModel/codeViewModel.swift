import Foundation
import CloudKit
import SwiftUI

struct CodeModel: Identifiable, Hashable {
    let id = UUID()
    var code: String
    var creatorUsername: String
    var creatorID: String
    var users: [String] // List of user IDs associated with the code
    var isClicked: Bool // New property to track toggle state
    var record: CKRecord
}

class CodeViewModel: ObservableObject {
    @Published var code: String = ""
    @Published var creatorUsername: String = ""
    @Published var currentCode: CodeModel?
    
    func addCode(newCode: String, creatorUsername: String, creatorID: String) {
        let newCodeRecord = CKRecord(recordType: "Sessions") // Changed to "Sessions"
        newCodeRecord["code"] = newCode
        newCodeRecord["creatorUsername"] = creatorUsername
        newCodeRecord["creatorID"] = creatorID
        newCodeRecord["users"] = [creatorID] // Initialize with the creator's ID
        newCodeRecord["isClicked"] = false // Initialize isClicked to false
        
        saveCode(record: newCodeRecord)
    }
    
    private func saveCode(record: CKRecord) {
        CKContainer.default().publicCloudDatabase.save(record) { [weak self] returnedRecord, returnedError in
            if let savedRecord = returnedRecord {
                DispatchQueue.main.async {
                    let code = savedRecord["code"] as? String ?? ""
                    let creatorUsername = savedRecord["creatorUsername"] as? String ?? ""
                    let creatorID = savedRecord["creatorID"] as? String ?? ""
                    let users = savedRecord["users"] as? [String] ?? []
                    let isClicked = savedRecord["isClicked"] as? Bool ?? false
                    
                    self?.currentCode = CodeModel(code: code, creatorUsername: creatorUsername, creatorID: creatorID, users: users, isClicked: isClicked, record: savedRecord)
                }
            }
        }
    }
    
    func fetchCode(byCode code: String) {
        let predicate = NSPredicate(format: "code == %@", code)
        let query = CKQuery(recordType: "Sessions", predicate: predicate) // Changed to "Sessions"
        let queryOperation = CKQueryOperation(query: query)
        
        queryOperation.recordMatchedBlock = { [weak self] (returnedRecordID, returnedResult) in
            switch returnedResult {
            case .success(let record):
                guard let code = record["code"] as? String,
                      let creatorUsername = record["creatorUsername"] as? String,
                      let creatorID = record["creatorID"] as? String,
                      let users = record["users"] as? [String],
                      let isClicked = record["isClicked"] as? Bool else { return }
                
                DispatchQueue.main.async {
                    self?.currentCode = CodeModel(code: code, creatorUsername: creatorUsername, creatorID: creatorID, users: users, isClicked: isClicked, record: record)
                }
                
            case .failure(let error):
                print("Failed to fetch code: \(error.localizedDescription)")
            }
        }
        
        addOperation(operation: queryOperation)
    }
    
    func toggleIsClicked() {
        guard let currentRecord = currentCode?.record else { return }
        
        let currentIsClicked = currentRecord["isClicked"] as? Bool ?? false
        currentRecord["isClicked"] = !currentIsClicked
        
        saveCode(record: currentRecord)
    }
    
    func deleteCurrentCode() {
        guard let currentRecord = currentCode?.record else { return }
        
        CKContainer.default().publicCloudDatabase.delete(withRecordID: currentRecord.recordID) { [weak self] deletedRecordID, deletedError in
            DispatchQueue.main.async {
                if deletedError == nil {
                    self?.currentCode = nil // Clear the current code after deletion
                } else {
                    print("Failed to delete record: \(deletedError!.localizedDescription)")
                }
            }
        }
    }
    
    func addOperation(operation: CKDatabaseOperation) {
        CKContainer.default().publicCloudDatabase.add(operation)
    }
}









