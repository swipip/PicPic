//
//  ListWebEntry.swift
//  Picpic
//
//  Created by Gautier Billard on 03/09/2021.
//

import Foundation

struct ListWebEntry: WebServiceEntry {
    
    private (set) var path = "photos"
    private (set) var host = "https://api.unsplash.com/"
    
    var url: URL {
        return URL(string: host + path + "?" + apiKey)!
    }

}
