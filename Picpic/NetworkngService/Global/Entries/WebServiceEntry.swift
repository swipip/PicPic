//
//  WebServiceEntry.swift
//  Picpic
//
//  Created by Gautier Billard on 03/09/2021.
//

import Foundation

protocol WebServiceEntry {
    var path: String { get }
    var host: String { get }
    var url: URL { get }
}
extension WebServiceEntry {
    
    private var noApiKeyMessage: String {
        """
        WARNING --\
        Api key is not provided in the project. Please upload a valid plist file containing the unplash apiKey \
        --
        """
    }
    
    var apiKey: String {

        guard let url = Bundle.main.url(forResource: "keys", withExtension: "plist"),
              let dict = NSDictionary(contentsOf: url),
              let key = dict["apiKey"] as? String
              else {
            print(noApiKeyMessage)
            return ""
        }
        return "&client_id=" + key

    }
}
