//
//  Photo.swift
//  Picpic
//
//  Created by Gautier Billard on 03/09/2021.
//

import Foundation

struct Photo: Decodable, Hashable, Picturable {
    var id: String
    var urls: URLS
    var user: User
    var likes: Int
    
    var likesString: String {
        return "\(likes) like" + "\(likes > 1 ? "s" : "")"
    }
}
struct URLS: Decodable, Hashable {
    var raw: String?
    var full: String?
    var regular: String?
    var small: String?
    var thumb: String?
    var medium: String?
    var large: String?
}
struct User: Decodable, Hashable {
    var id: String
    var username: String
    var name: String
    var profile_image: URLS
}

protocol Picturable {
    var id: String { get }
    var urls: URLS { get }
}
