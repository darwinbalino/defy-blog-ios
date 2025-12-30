//
//  Publication.swift
//  DefyBlog
//
//  Model representing content publishers/blogs
//

import Foundation

struct Publication: Codable, Identifiable {
    let id: String
    let name: String
    let slug: String
    let description: String
    let avatarURL: String
    let blogURL: String
    let topicId: String
    let topics: [String]
    let followerCount: Int
    let articleCount: Int
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case description
        case avatarURL
        case blogURL
        case topicId
        case topics
        case followerCount
        case articleCount
        case createdAt
    }
}

// MARK: - Firestore Conversion
extension Publication {
    /// Initialize Publication from Firestore dictionary
    init?(id: String, data: [String: Any]) {
        guard
            let name = data["name"] as? String,
            let slug = data["slug"] as? String,
            let description = data["description"] as? String,
            let avatarURL = data["avatarURL"] as? String,
            let blogURL = data["blogURL"] as? String,
            let topicId = data["topicId"] as? String,
            let topics = data["topics"] as? [String]
        else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.slug = slug
        self.description = description
        self.avatarURL = avatarURL
        self.blogURL = blogURL
        self.topicId = topicId
        self.topics = topics
        self.followerCount = data["followerCount"] as? Int ?? 0
        self.articleCount = data["articleCount"] as? Int ?? 0
        self.createdAt = (data["createdAt"] as? Date) ?? Date()
    }
}
