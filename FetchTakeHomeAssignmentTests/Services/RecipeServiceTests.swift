//
//  RecipeServiceTests.swift
//  FetchTakeHomeAssignmentTests
//
//  Created by Benjamin Ashamole on 3/12/25.
//

import XCTest
@testable import FetchTakeHomeAssignment

final class RecipeServiceTests: XCTestCase {
    
    var mockSession: URLSession!
    var sut: RecipeService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        mockSession = URLSession(configuration: config)
        APIService.shared.session = mockSession
        sut = RecipeService()
    }

    override func tearDownWithError() throws {
        MockURLProtocol.requestHandler = nil
        sut = nil
        mockSession = nil
        try super.tearDownWithError()
    }
    
    func testLoadRecipe_SuccessCase() async {

        let data = RecipeList(recipes: [
            Recipe(id: UUID().uuidString, name: "Chocolate Lava Cake", cuisine: .american),
            Recipe(id: UUID().uuidString, name: "Pizza", cuisine: .italian),
            Recipe(id: UUID().uuidString, name: "Gyro", cuisine: .greek)
        ])
        
        guard let mockData = try? JSONEncoder().encode(data) else {
            XCTFail()
            return
        }
        
        MockURLProtocol.requestHandler = { requet in
            let response = HTTPURLResponse(url: requet.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, mockData)
        }
        
        let expectation = self.expectation(description: "Success case, recipes are loaded")
        
        let result = await sut.loadRecipes()
        switch result {
        case .success(let data):
            XCTAssertFalse(data.isEmpty)
            XCTAssertEqual(data.count, 3)
        case .failure:
            XCTFail()
        }
        
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    func testLoadRecipe_FailureCase() async {
        let data = Recipe(id: UUID().uuidString, name: "Cheese Burger", cuisine: .american)
        
        guard let mockData = try? JSONEncoder().encode(data) else {
            XCTFail()
            return
        }
        
        MockURLProtocol.requestHandler = { requet in
            let response = HTTPURLResponse(url: requet.url!, statusCode: 404, httpVersion: nil, headerFields: nil)!
            return (response, mockData)
        }
        
        let expectation = self.expectation(description: "Failure case, recipes are not loaded")
        
        let result = await sut.loadRecipes()
        switch result {
        case .success:
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error, .failedToFetchRecipes)
        }
        
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 1)
    }

}
