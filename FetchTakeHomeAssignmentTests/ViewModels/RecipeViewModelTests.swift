//
//  RecipeViewModelTests.swift
//  FetchTakeHomeAssignmentTests
//
//  Created by Benjamin Ashamole on 3/12/25.
//

import XCTest
@testable import FetchTakeHomeAssignment

final class RecipeViewModelTests: XCTestCase {

    var sut: RecipeViewModel!
    var mockRecipeService: MockRecipeService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockRecipeService = MockRecipeService()
        sut = RecipeViewModel(recipeService: mockRecipeService)
        sut.recipes = [
            Recipe(id: UUID().uuidString, name: "Chocolate Lava Cake", cuisine: .american),
            Recipe(id: UUID().uuidString, name: "Pizza", cuisine: .italian),
            Recipe(id: UUID().uuidString, name: "Gyro", cuisine: .greek)
        ]
    }

    override func tearDownWithError() throws {
        sut.recipes = []
        mockRecipeService = nil
        sut = nil
    }
    
    func testFilterBy() async {
        // given
        XCTAssertNil(sut.currentSelectedCusine)
        XCTAssertEqual(sut.recipeList.count, 0)
        
        // when
        await sut.filterBy(cuisine: .american)
        
        // then
        XCTAssertNotNil(sut.currentSelectedCusine)
        XCTAssertEqual(sut.currentSelectedCusine, .american)
        XCTAssertEqual(sut.recipeList.count, 1)
    }
    
    func testLoadRecipes_SuccessCase() async {
        // given
        XCTAssertEqual(sut.recipeList.count, 0)
        
        // when
        await sut.loadRecipes()
        
        // then
        XCTAssertEqual(sut.recipes.count, 3)
        XCTAssertEqual(sut.recipes.count, 3)
    }
    
    func testLoadRecipes_FailureCase() async {
        // given
        XCTAssertEqual(sut.recipeList.count, 0)
        
        // when
        mockRecipeService.isSuccessCase = false
        await sut.loadRecipes()
        
        // then
        XCTAssertEqual(sut.recipes.count, 0)
    }

}
