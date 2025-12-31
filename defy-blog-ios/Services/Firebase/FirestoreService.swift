//
//  FirestoreService.swift
//  DefyBlog
//
//  Base service class for Firestore database operations
//

import Foundation
import FirebaseFirestore

class FirestoreService {
    // MARK: - Properties
    let db = Firestore.firestore()
    
    // MARK: - Generic CRUD Operations
    
    /// Create a document in a collection
    func create<T: Encodable>(
        _ object: T,
        in collection: String,
        documentId: String? = nil
    ) async throws -> String {
        let docRef: DocumentReference
        
        if let documentId = documentId {
            docRef = db.collection(collection).document(documentId)
        } else {
            docRef = db.collection(collection).document()
        }
        
        try docRef.setData(from: object)
        return docRef.documentID
    }
    
    /// Read a document from a collection
    func read<T: Decodable>(
        from collection: String,
        documentId: String,
        as type: T.Type
    ) async throws -> T? {
        let snapshot = try await db.collection(collection)
            .document(documentId)
            .getDocument()
        
        guard snapshot.exists else { return nil }
        return try snapshot.data(as: type)
    }
    
    /// Update a document in a collection
    func update(
        in collection: String,
        documentId: String,
        data: [String: Any]
    ) async throws {
        try await db.collection(collection)
            .document(documentId)
            .updateData(data)
    }
    
    /// Delete a document from a collection
    func delete(
        from collection: String,
        documentId: String
    ) async throws {
        try await db.collection(collection)
            .document(documentId)
            .delete()
    }
    
    /// Fetch all documents from a collection
    func fetchAll<T: Decodable>(
        from collection: String,
        as type: T.Type,
        limit: Int? = nil
    ) async throws -> [T] {
        var query: Query = db.collection(collection)
        
        if let limit = limit {
            query = query.limit(to: limit)
        }
        
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: type) }
    }
    
    /// Fetch documents with a query
    func fetch<T: Decodable>(
        from collection: String,
        where field: String,
        isEqualTo value: Any,
        as type: T.Type,
        limit: Int? = nil
    ) async throws -> [T] {
        var query: Query = db.collection(collection).whereField(field, isEqualTo: value)
        
        if let limit = limit {
            query = query.limit(to: limit)
        }
        
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: type) }
    }
    
    /// Check if document exists
    func exists(
        in collection: String,
        documentId: String
    ) async throws -> Bool {
        let snapshot = try await db.collection(collection)
            .document(documentId)
            .getDocument()
        return snapshot.exists
    }
    
    /// Batch write operations
    func batchWrite(operations: @escaping (WriteBatch) -> Void) async throws {
        let batch = db.batch()
        operations(batch)
        try await batch.commit()
    }
}

// MARK: - Error Handling
extension FirestoreService {
    enum FirestoreError: LocalizedError {
        case documentNotFound
        case encodingFailed
        case decodingFailed
        case operationFailed(String)
        
        var errorDescription: String? {
            switch self {
            case .documentNotFound:
                return "The requested document was not found."
            case .encodingFailed:
                return "Failed to encode data."
            case .decodingFailed:
                return "Failed to decode data."
            case .operationFailed(let message):
                return "Operation failed: \(message)"
            }
        }
    }
}
