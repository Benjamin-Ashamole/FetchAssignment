//
//  RecipeServiceMock.swift
//  FetchTakeHomeAssignmentTests
//
//  Created by Benjamin Ashamole on 3/12/25.
//

import Foundation
@testable import FetchTakeHomeAssignment

class MockRecipeService: RecipeServiceProtocol {
    
    var isSuccessCase: Bool
    
    init(isSuccessCase: Bool = true) {
        self.isSuccessCase = isSuccessCase
    }
    
    func loadRecipes() async -> Result<[Recipe], RecipeServiceError> {
        if isSuccessCase {
            return .success([
                Recipe(id: UUID().uuidString, name: "Chocolate Lava Cake", cuisine: .american),
                Recipe(id: UUID().uuidString, name: "Pizza", cuisine: .italian),
                Recipe(id: UUID().uuidString, name: "Gyro", cuisine: .greek)
            ])
        }
        return .failure(RecipeServiceError.failedToFetchRecipes)
    }
    
    
}
