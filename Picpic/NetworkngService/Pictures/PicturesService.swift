//
//  PicturesService.swift
//  Picpic
//
//  Created by Gautier Billard on 03/09/2021.
//

import Foundation

class PicturesService {

    static let shared = PicturesService()

    private var testMode = false

    var cache = NSCache<NSString, NSData>()

    private var debouncer: DispatchWorkItem?

    typealias PictureServiceBlock = (_ result: Result<[Photo], Error>) -> Void
    func getListOfImages(_ completion: @escaping PictureServiceBlock) {

        if testMode {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(.success(self.getMock()))
            }
            return
        }

        NetworkingService.shared.get(endPoint: .list) { result in
            switch result {
            case .success(let data):
                do {
                    let images = try JSONDecoder().decode([Photo].self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(images))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            case .failure(let err):
                completion(.failure(err))
            }
        }

    }

    func getUsersPictures(userName: String, _ completion: @escaping PictureServiceBlock) {

        if testMode {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(.success(self.getMock()))
            }
            return
        }

        NetworkingService.shared.get(endPoint: .user(userName: userName)) { result in
            switch result {
            case .success(let data):
                do {
                    let images = try JSONDecoder().decode([Photo].self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(images))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            case .failure(let err):
                DispatchQueue.main.async {
                    completion(.failure(err))
                }
            }
        }
    }

    func getStatistics(forPictureId id: String, _ completion: @escaping (_ stats: Stats) -> Void) {

        guard !testMode else {
            return
        }

        func decode(_ data: Data) -> Stats? {
            do {
                let model = try JSONDecoder().decode(Stats.self, from: data)
                self.cache.setObject(data as NSData, forKey: NSString(string: model.id))
                return model
            } catch {
                return nil
            }
        }

        if let data = cache.object(forKey: NSString(string: id)) as Data? {
            guard let model = decode(data) else {return}
            completion(model)
            return
        }

        debouncer?.cancel()
        debouncer = .init(block: {
            NetworkingService.shared.get(endPoint: .stats(pictureId: id)) { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        guard let model = decode(data) else {return}
                        completion(model)
                    }
                case .failure(_):
                    break
                }
            }
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: debouncer!)
    }

    private func getMock() -> [Photo] {
        guard let url = Bundle.main.url(forResource: "SamplePhotos", withExtension: "json") else {return []}
        do {
            let data = try Data(contentsOf: url)
            let photos = try JSONDecoder().decode([Photo].self, from: data)
            return photos
        } catch {
            return []
        }
    }

}
