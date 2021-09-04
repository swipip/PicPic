//
//  Stats.swift
//  Picpic
//
//  Created by Gautier Billard on 03/09/2021.
//

import Foundation

struct Stats: Decodable, Identifiable {
    var id: String
    var downloads: Downloads
    var views: Views
}
struct Views: Decodable, Statable {
    var desc: String {
        "\(total) view\(total > 1 ? "s" : "")"
    }
    var total: Int
}
struct Downloads: Decodable, Statable {
    var desc: String {
        "\(total) download\(total > 1 ? "s" : "")"
    }
    var total: Int
}
protocol Statable {
    var total: Int { get set }
    var desc: String { get }
}
