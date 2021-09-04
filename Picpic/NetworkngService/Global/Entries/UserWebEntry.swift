//
//  UserWebEntry.swift
//  Picpic
//
//  Created by Gautier Billard on 03/09/2021.
//

import Foundation

struct UserWebEntry: WebServiceEntry {
    
    var path = "users/%@/photos"
    var host = "https://api.unsplash.com/"
    
    private (set) var userName = ""
    
    init(_ userName: String) {
        self.userName = userName
    }
    
    var url: URL {
        return URL(string: host + String(format: path, userName) + "?" + apiKey)!
    }
    
}
