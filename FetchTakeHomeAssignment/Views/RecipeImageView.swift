//
//  RecipeImageView.swift
//  FetchTakeHomeAssignment
//
//  Created by Benjamin Ashamole on 3/12/25.
//

import SwiftUI

struct RecipeImageView : View {
    @State private var image: UIImage? = nil
    let urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
    }
       
       var body: some View {
           VStack {
               if let image = image {
                   Image(uiImage: image)
                       .resizable()
                       .scaledToFit()
                       .frame(width: 100, height: 100)
                       .clipShape(.rect(cornerRadius: 5))
               } else {
                   ProgressView()
               }
           }
           .onAppear {
               loadImage()
           }
       }
       
       private func loadImage() {
           RecipeImageCacheManager.shared.load(urlString: urlString) { image in
               if let recipeImage = image {
                   self.image = recipeImage
               } else {
                   self.image = UIImage(systemName: "birthday.cake")
               }
           }
       }
}
