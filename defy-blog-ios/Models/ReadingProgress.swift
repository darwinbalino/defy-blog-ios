//
//  ReadingProgress.swift
//  DefyBlog
//
//  Model tracking user's reading progress for articles
//

import Foundation

struct ReadingProgress: Codable {
    let articleId: String
    var lastReadAt: Date
    var progress: Double // 0-100
    var isCompleted: Bool
    
    enum CodingKeys: String, CodingKey {
        case articleId
        case lastReadAt
        case progress
        case isCompleted
    }
    
    init(
        articleId: String,
        lastReadAt: Date = Date(),
        progress: Double = 0.0,
        isCompleted: Bool = false
    ) {
        self.articleId = articleId
        self.lastReadAt = lastReadAt
        self.progress = progress
        self.isCompleted = isCompleted
    }
}

// MARK: - Firestore Conversion
extension ReadingProgress {
    /// Convert ReadingProgress to Firestore dictionary
    var firestoreData: [String: Any] {
        return [
            "articleId": articleId,
            "lastReadAt": lastReadAt,
            "progress": progress,
            "isCompleted": isCompleted
        ]
    }
    
    /// Initialize ReadingProgress from Firestore dictionary
    init?(data: [String: Any]) {
        guard let articleId = data["articleId"] as? String else {
            return nil
        }
        
        self.articleId = articleId
        self.lastReadAt = (data["lastReadAt"] as? Date) ?? Date()
        self.progress = data["progress"] as? Double ?? 0.0
        self.isCompleted = data["isCompleted"] as? Bool ?? false
    }
}

// MARK: - Progress Helpers
extension ReadingProgress {
    /// Check if article has been started
    var isStarted: Bool {
        progress > 0
    }
    
    /// Progress percentage as formatted string
    var progressPercentage: String {
        String(format: "%.0f%%", progress)
    }
    
    /// Mark as completed
    mutating func markCompleted() {
        self.progress = 100.0
        self.isCompleted = true
        self.lastReadAt = Date()
    }
    
    /// Update reading progress
    mutating func updateProgress(_ newProgress: Double) {
        self.progress = min(max(newProgress, 0), 100)
        self.lastReadAt = Date()
        
        if self.progress >= 100 {
            self.isCompleted = true
        }
    }
}
