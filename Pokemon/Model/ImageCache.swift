//
//  ImageCache.swift
//  Pokemon
//
//  Created by Mduduzi Mthethwa on 2024/01/31.
//

import Foundation
import UIKit
public class ImageCache {
    public static let shared = ImageCache()
    private let imageCache = NSCache<NSURL, UIImage>()
    
    private init() {}
    
    public func getImage(url: URL) -> UIImage? {
        return imageCache.object(forKey: url as NSURL)
    }
    
    public func setImage(_ image: UIImage, for url: URL) {
        imageCache.setObject(image, forKey: url as NSURL)
    }
}
