//
//  NetworkingService.swift
//  Picpic
//
//  Created by Gautier Billard on 03/09/2021.
//

import Foundation

class NetworkingService {
        
    static let shared = NetworkingService()
    
    enum EndPoint {
        case list
        case user(userName: String)
        case stats(pictureId: String)
        
        var entry: WebServiceEntry {
            switch self {
            case .list:
                return ListWebEntry()
            case .user(let userName):
                return UserWebEntry(userName)
            case .stats(let pictureId):
                return PicStatsWebEntry(pictureId)
            }
        }
    }
    typealias NetworkingCompletionBlock = ((_ result: Result<Data,Error>)->())
    func get(endPoint: EndPoint, _ completion: @escaping NetworkingCompletionBlock) {
        
        let session = URLSession.shared
        let request = URLRequest(url: endPoint.entry.url)
        let task = session.dataTask(with: request) { data, response, error in
            print("call: \(request.url?.absoluteString ?? "")")
            if let err = error {
                completion(.failure(err))
            } else if let data = data {
                completion(.success(data))
            }
        }
        task.resume()
        
    }
    
}

class ApiResponseHandler {
    
}
