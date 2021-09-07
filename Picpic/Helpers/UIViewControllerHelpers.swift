//
//  ViewControllerHelpers.swift
//  Picpic
//
//  Created by Gautier Billard on 03/09/2021.
//

import UIKit

extension UIViewController {
    func embedInNav() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }

    var safeAreaInsetsWithNavBar: UIEdgeInsets {
        let safeArea = UIApplication.shared.windows.first?.safeAreaInsets ?? .zero
        let topSafe = (safeArea.top) + UINavigationController().navigationBar.frame.height
        return UIEdgeInsets(top: topSafe, left: safeArea.left, bottom: safeArea.bottom, right: safeArea.right)
    }
}
