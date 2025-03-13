//
//  RecipeViewModel.swift
//  FetchTakeHomeAssignment
//
//  Created by Benjamin Ashamole on 3/11/25.
//

import Foundation

final class RecipeViewModel: ObservableObject {
    @Published var recipeList: [Recipe] = []
    @Published var currentSelectedCusine: Cuisine? = nil
    @Published var status: ServiceCallStatus = .idle
    
    var recipes: [Recipe] = []
    
    var recipeService: RecipeServiceProtocol
    
    init(recipeService: RecipeServiceProtocol = RecipeService()) {
        self.recipeService = recipeService
    }
    
    @MainActor
    func loadRecipes() async {
        status = .loading
        let result = await recipeService.loadRecipes()
        switch result {
        case .success(let recipes):
            self.recipeList = recipes
            self.recipes = recipes
        case .failure:
            self.recipeList = []
            self.recipes = []
        }
        status = .idle
    }
    
    @MainActor
    func filterBy(cuisine: Cuisine?) {
        guard cuisine != nil else {
            recipeList = recipes
            return
        }
        
        let filteredRecipes = recipes.filter { $0.cuisine == cuisine }
        recipeList = filteredRecipes
        currentSelectedCusine = cuisine
    }
}
