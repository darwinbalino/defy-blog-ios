//
//  Topic.swift
//  DefyBlog
//
//  Model representing content topics/categories
//

import Foundation

struct Topic: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let slug: String
    let description: String
    let iconName: String
    let color: String
    let order: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case description
        case iconName
        case color
        case order
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Topic, rhs: Topic) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Firestore Conversion
extension Topic {
    /// Initialize Topic from Firestore dictionary
    init?(id: String, data: [String: Any]) {
        guard
            let name = data["name"] as? String,
            let slug = data["slug"] as? String,
            let description = data["description"] as? String,
            let iconName = data["iconName"] as? String,
            let color = data["color"] as? String,
            let order = data["order"] as? Int
        else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.slug = slug
        self.description = description
        self.iconName = iconName
        self.color = color
        self.order = order
    }
}
