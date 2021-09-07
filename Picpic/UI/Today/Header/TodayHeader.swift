//
//  TodayHeader.swift
//  Picpic
//
//  Created by Gautier Billard on 03/09/2021.
//

import UIKit

class TodayHeader: UICollectionReusableView, Reusable {
    static var reuseId = "TodayHeader"

    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            let date = Date()
            let formater = DateFormatter()
            formater.dateStyle = .long
            dateLabel.text = formater.string(from: date)
        }
    }

}
