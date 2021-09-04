//
//  EdgeInsetsHelpers.swift
//  Picpic
//
//  Created by Gautier Billard on 03/09/2021.
//

import UIKit

extension UIEdgeInsets {
    static func all(_ margin: CGFloat) -> UIEdgeInsets {
        return .init(top: margin, left: margin, bottom: margin, right: margin)
    }
}
