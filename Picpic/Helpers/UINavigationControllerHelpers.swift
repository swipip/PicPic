//
//  UINavigationControllerHelpers.swift
//  Picpic
//
//  Created by Gautier Billard on 03/09/2021.
//

import UIKit

extension UINavigationController {
    func clearNavBar() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
    }
}
