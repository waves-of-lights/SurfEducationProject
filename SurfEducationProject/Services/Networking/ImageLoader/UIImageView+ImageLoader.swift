//
//  UIImageView+ImageLoader.swift
//  SurfEducationProject
//
//  Created by Anastasia Anisimova on 21.08.2022.//

import UIKit

extension UIImageView {
    typealias LoadResult = (UIImage, URL) -> Void

    func loadImage(from url: URL) {
        ImageLoader().loadImage(from: url) { [weak self] result in
            if case let .success(image) = result {

                
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
    
    
    /// Loads image from web asynchronously and caches it, in case you have to load url
    /// again, it will be loaded from cache if available
    func load(url: URL?, placeholder: UIImage?, cache: URLCache? = nil, completion: LoadResult? = nil) {
        guard let url = url else { return }
        let cache = cache ?? URLCache.shared
        let request = URLRequest(url: url)
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            completion?(image, url)
        } else {
            image = placeholder
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async {
                        completion?(image, url)
                    }
                }
            }).resume()
        }
    }
}
