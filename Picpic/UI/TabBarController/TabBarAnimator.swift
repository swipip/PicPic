//
//  TabBarAnimator.swift
//  Picpic
//
//  Created by Gautier Billard on 03/09/2021.
//

import UIKit

class TabBarControllerAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var duration: TimeInterval = 0.25
    var direction: AnimationDirection = .fromRight
    
    enum AnimationDirection {
        case fromRight, fromLeft
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if let fromView = transitionContext.viewController(forKey: .from)?.view,
           let toView = transitionContext.viewController(forKey: .to)?.view {
            
            let container = transitionContext.containerView
            
            let travelDistance = UIScreen.main.bounds.width
            
            switch direction {
            case .fromLeft:
                toView.transform = .init(translationX: -travelDistance, y: 0)
                container.addSubview(toView)
                
                UIView.animate(withDuration: duration) {
                    toView.transform = .identity
                    fromView.transform = .init(translationX: travelDistance, y: 0)
                } completion: { finished in
                    fromView.transform = .identity
                    transitionContext.completeTransition(finished)
                }
            case .fromRight:
                toView.transform = .init(translationX: travelDistance, y: 0)
                container.addSubview(toView)
                
                UIView.animate(withDuration: duration) {
                    toView.transform = .identity
                    fromView.transform = .init(translationX: -travelDistance, y: 0)
                } completion: { finished in
                    fromView.transform = .identity
                    transitionContext.completeTransition(finished)
                }
            }
            
           } else {
                fatalError("Missing controller(s) in tabBar transition animation")
           }
    }
}
