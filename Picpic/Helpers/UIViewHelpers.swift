//
//  UIViewHelpers.swift
//  Picpic
//
//  Created by Gautier Billard on 03/09/2021.
//

import UIKit

extension UIView {
    func shadow(color: UIColor, opacity: Float, radius: CGFloat, offset: CGSize = .zero) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = offset
    }
    func animateAlpha(on: Bool, _ completion: (()->())? = nil) {
        UIView.animate(withDuration: 0.2) {
            self.alpha = on ? 1 : 0
        } completion: { _ in
            completion?()
        }
    }
    func addSubview(pinToEdges constant: CGFloat, subView: UIView) {
        
        let childView: UIView = subView
        let mView: UIView = self
        
        self.addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = false
        
        childView.leadingAnchor.constraint(equalTo: mView.leadingAnchor, constant: constant).isActive = true
        childView.topAnchor.constraint(equalTo: mView.topAnchor, constant: constant).isActive = true
        childView.bottomAnchor.constraint(equalTo: mView.bottomAnchor,constant: constant).isActive = true
        childView.trailingAnchor.constraint(equalTo: mView.trailingAnchor,constant: constant).isActive = true
        
    }
}
