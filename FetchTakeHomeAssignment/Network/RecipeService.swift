//
//  RecipeService.swift
//  FetchTakeHomeAssignment
//
//  Created by Benjamin Ashamole on 3/12/25.
//

import Foundation

protocol RecipeServiceProtocol {
    func loadRecipes() async -> Result<[Recipe], RecipeServiceError>
}

enum RecipeServiceError: Error {
    case badUrl
    case failedToFetchRecipes
}

enum RecipeServiceAction {
    case loadRecipes
    
    var urlString: String {
        switch self {
        case .loadRecipes: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        }
    }
    
    var httpMethod: String {
        switch self {
        case .loadRecipes: "GET"
        }
    }
}

final class RecipeService: RecipeServiceProtocol, ApiCalling {
    func makeURLRequest(for action: RecipeServiceAction) throws -> URLRequest {
        switch action {
        case .loadRecipes:
            guard let url = URL(string: action.urlString) else {
                throw RecipeServiceError.badUrl
            }
            var request = URLRequest(url: url)
            request.httpMethod = action.httpMethod
            request.timeoutInterval = 10
            return request
        }
    }
    
    func loadRecipes() async -> Result<[Recipe], RecipeServiceError> {
        do {
            let request = try makeURLRequest(for: .loadRecipes)
            let result = try await APIService.shared.makeRequest(request, returnModel: RecipeList.self)
            switch result {
            case .success(let recipelist):
                return .success(recipelist.recipes)
            case .failure:
                return .failure(RecipeServiceError.failedToFetchRecipes)
            }
        } catch {
            return .failure(RecipeServiceError.failedToFetchRecipes)
        }
    }
    
    
}
