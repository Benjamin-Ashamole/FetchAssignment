//
//  Recipe.swift
//  FetchTakeHomeAssignment
//
//  Created by Benjamin Ashamole on 3/11/25.
//

import Foundation

struct Recipe: Codable, Identifiable {
    
    let id: String
    let name: String
    let cuisine: Cuisine
    let urlLarge: String?
    let urlSmall: String?
    let source: String?
    let youtubeUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case cuisine
        case urlLarge = "photo_url_large"
        case urlSmall = "photo_url_small"
        case source = "source_url"
        case youtubeUrl = "youtube_url"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.cuisine = try container.decode(Cuisine.self, forKey: .cuisine)
        self.urlLarge = try container.decodeIfPresent(String.self, forKey: .urlLarge)
        self.urlSmall = try container.decodeIfPresent(String.self, forKey: .urlSmall)
        self.source = try container.decodeIfPresent(String.self, forKey: .source)
        self.youtubeUrl = try container.decodeIfPresent(String.self, forKey: .youtubeUrl)
    }
    
}

extension Recipe {
    init(id: String, name: String, cuisine: Cuisine, urlLarge: String? = nil, urlSmall: String? = nil, source: String? = nil, youtubeUrl: String? = nil) {
        self.id = id
        self.name = name
        self.cuisine = cuisine
        self.urlLarge = urlLarge
        self.urlSmall = urlSmall
        self.source = source
        self.youtubeUrl = youtubeUrl
    }
}

struct RecipeList: Codable {
    let recipes: [Recipe]
}

enum Cuisine: String, Codable, CaseIterable, Identifiable {
    
    var id: String {
        UUID().uuidString
    }
    
    case british
    case malaysian
    case american
    case canadian
    case italian
    case tunisian
    case french
    case greek
    case polish
    case portuguese
    case russian
    case croatian
    case other
    
    init(from decoder: any Decoder) throws {
        
        let value = try decoder.singleValueContainer()
        let cuisine = try value.decode(String.self)
        
        switch cuisine {
        case "British": self = .british
        case "Malaysian": self = .malaysian
        case "American": self = .american
        case "Canadian": self = .canadian
        case "Italian": self = .italian
        case "Tunisian": self = .tunisian
        case "French": self = .french
        case "Greek": self = .greek
        case "Polish": self = .polish
        case "Portuguese": self = .portuguese
        case "Russian": self = .russian
        case "Croatian": self = .croatian
        default: self = .other
        }
    }
}
