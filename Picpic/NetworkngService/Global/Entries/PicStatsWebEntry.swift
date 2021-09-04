//
//  PicStatsWebEntry.swift
//  Picpic
//
//  Created by Gautier Billard on 03/09/2021.
//

import Foundation

struct PicStatsWebEntry: WebServiceEntry {
    
    var path = "photos/%@/statistics"
    var host = "https://api.unsplash.com/"
    
    private (set) var picId = ""
    
    init(_ picId: String) {
        self.picId = picId
    }
    
    var url: URL {
        return URL(string: host + String(format: path, picId) + "?" + apiKey)!
    }
    
}
