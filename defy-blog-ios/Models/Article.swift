//
//  Article.swift
//  DefyBlog
//
//  Model representing blog articles/posts
//

import Foundation

struct Article: Codable, Identifiable {
    let id: String
    let title: String
    let slug: String
    let featuredQuote: String
    let content: String // Markdown format
    let authorName: String
    let authorAvatarURL: String?
    let publishedAt: Date
    let originalPublishDate: Date
    let readTimeMinutes: Int
    let coverImageURL: String?
    let publicationId: String
    let topicId: String
    let recommendCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case slug
        case featuredQuote
        case content
        case authorName
        case authorAvatarURL
        case publishedAt
        case originalPublishDate
        case readTimeMinutes
        case coverImageURL
        case publicationId
        case topicId
        case recommendCount
    }
}

// MARK: - Firestore Conversion
extension Article {
    /// Initialize Article from Firestore dictionary
    init?(id: String, data: [String: Any]) {
        guard
            let title = data["title"] as? String,
            let slug = data["slug"] as? String,
            let featuredQuote = data["featuredQuote"] as? String,
            let content = data["content"] as? String,
            let authorName = data["authorName"] as? String,
            let publicationId = data["publicationId"] as? String,
            let topicId = data["topicId"] as? String,
            let readTimeMinutes = data["readTimeMinutes"] as? Int
        else {
            return nil
        }
        
        self.id = id
        self.title = title
        self.slug = slug
        self.featuredQuote = featuredQuote
        self.content = content
        self.authorName = authorName
        self.authorAvatarURL = data["authorAvatarURL"] as? String
        self.publishedAt = (data["publishedAt"] as? Date) ?? Date()
        self.originalPublishDate = (data["originalPublishDate"] as? Date) ?? Date()
        self.readTimeMinutes = readTimeMinutes
        self.coverImageURL = data["coverImageURL"] as? String
        self.publicationId = publicationId
        self.topicId = topicId
        self.recommendCount = data["recommendCount"] as? Int ?? 0
    }
}

// MARK: - Computed Properties
extension Article {
    /// Formatted read time string (e.g., "5 min read")
    var readTimeText: String {
        "\(readTimeMinutes) min read"
    }
    
    /// Formatted publish date
    var formattedPublishDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: publishedAt)
    }
}
