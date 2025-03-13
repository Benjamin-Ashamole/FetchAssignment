//
//  RecipeImageCacheManager.swift
//  FetchTakeHomeAssignment
//
//  Created by Benjamin Ashamole on 3/12/25.
//

import Foundation

import SwiftUI

class RecipeImageCacheManager {
    static let shared = RecipeImageCacheManager()
    private let cache = NSCache<NSString, UIImage>()
    private let queue = DispatchQueue(label: "com.obillo1010.imagecache.queue", attributes: .concurrent)

    private init() {}

    func load(urlString: String, completion: @escaping (UIImage?) -> Void) {
        let key = NSString(string: urlString)
        
        queue.async {
            if let cachedImage = self.cache.object(forKey: key) {
                completion(cachedImage)
                return
            }
            guard let url = URL(string: urlString) else {
                completion(nil)
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    
                    self.queue.async(flags: .barrier) {
                        self.cache.setObject(image, forKey: key)
                   }
                    
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
            .resume()
        }
    }
}
