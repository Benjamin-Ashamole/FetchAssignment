//
//  RecipeListView.swift
//  FetchTakeHomeAssignment
//
//  Created by Benjamin Ashamole on 3/12/25.
//

import SwiftUI

struct RecipeListView: View {
    
    @StateObject var viewModel: RecipeViewModel = RecipeViewModel()
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                content
                    .toolbar {
                        ToolbarItemGroup(placement: .topBarTrailing) {
                            menuView
                    }
                }
                if viewModel.status == .loading {
                    ProgressView()
                }
            }
            .background(.white)
        }
    }
}

private extension RecipeListView {
    @ViewBuilder
    var content: some View {
        VStack {
            if viewModel.recipeList.isEmpty {
                emptyStateView
            } else {
                listView
            }
        }
        .navigationTitle("Recipes")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await viewModel.loadRecipes()
            }
        }
    }
    
    @ViewBuilder
    var listView: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach(viewModel.recipeList) { recipe in
                    LazyVStack {
                        HStack {
                            RecipeImageView(urlString: recipe.urlSmall ?? "")

                            VStack(alignment: .leading) {
                                Text(recipe.name)
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                Text(recipe.cuisine.rawValue.capitalized)
                            }
                            .foregroundStyle(.black)
                            .padding(.leading)
                            .padding(.vertical)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    Divider()
                }
                .padding(.horizontal)
            }
        }
        .refreshable {
            Task {
                await viewModel.loadRecipes()
            }
        }
    }
    
    @ViewBuilder
    var menuView: some View {
        Menu {
            Button {
                viewModel.filterBy(cuisine: nil)
            } label: {
                HStack {
                    if viewModel.currentSelectedCusine == nil {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10, height: 10)
                    }
                    Text("All")
                }

            }
            ForEach(Cuisine.allCases) { cuisine in
                Button {
                    viewModel.filterBy(cuisine: cuisine)
                } label: {
                    HStack {
                        if viewModel.currentSelectedCusine == cuisine {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 10, height: 10)
                        }
                        Text(cuisine.rawValue.uppercased())
                    }

                }
            }
        } label: {
            Button(action: {}, label: {
                Text("Sort by Cusine")
                    .foregroundStyle(.black)
            })
        }
    }
    
    @ViewBuilder
    var emptyStateView: some View {
        VStack {
            Text("No Recipes Found")
        }
    }
}

#Preview {
    RecipeListView()
}
