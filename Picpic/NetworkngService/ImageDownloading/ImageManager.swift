//
//  ImageManager.swift
//  Picpic
//
//  Created by Gautier Billard on 03/09/2021.
//

import UIKit

class ImageManager {
    
    static let shared = ImageManager()
    
    var cache = NSCache<NSString, NSData>()

    @discardableResult
    func loadImage(withUrlString urlString: String, for imageView: UIImageView) -> (() -> Void)? {
        
        var workItem: DispatchWorkItem?
        
        if let data = cache.object(forKey: .init(string: urlString)) {
            let queue = DispatchQueue(label: "decode image", qos: .userInitiated, attributes: .concurrent)
            workItem = DispatchWorkItem { [weak imageView] in
                let image = self.decodeImage(image: UIImage(data: data as Data))
                DispatchQueue.main.async {
                    imageView?.image = image
                }
            }
            queue.asyncAfter(deadline: .now() + 0.05, execute: workItem!)
            
        }
        let task = urlSession(urlString: urlString) { [weak imageView] result in
            switch result {
            case .success(let data):
                let encodedImage = UIImage(data: data)
                let image = self.decodeImage(image: encodedImage)
                DispatchQueue.main.async {
                    imageView?.image = image
                }
                
            case .failure(_):
                break
            }
        }
        
        let cancelTask: (() -> Void)?
        cancelTask = {
            workItem?.cancel()
            task?.cancel()
        }
        return cancelTask
    }
    
    @discardableResult
    private func urlSession(
        urlString: String,
        _ comletion: @escaping(_ result: Result<Data, Error>) -> Void) -> URLSessionDataTask? {
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                
                if let err = error as NSError? {
                    if err.code == -999 {
                        print("task canceled")
                    }
                    comletion(.failure(err))
                } else if let data = data {
                    
                    guard response?.url?.absoluteString == urlString else {return}
                    self.cache.setObject(
                        data as NSData, forKey: NSString(string: response?.url?.absoluteString ?? ""))
                    
                    comletion(.success(data))
                }
            }
            task.resume()
            return task
        }
        return nil
    }
    
    func precacheImage(urlString: String) {
        urlSession(urlString: urlString) { _ in }
    }
    
    private func decodeImage(image: UIImage?) -> UIImage? {
        guard let image = image else { return nil }
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        
        image.draw(at: CGPoint.zero)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}
