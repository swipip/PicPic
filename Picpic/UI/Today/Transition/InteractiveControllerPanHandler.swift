//
//  DetailControllerPanHandler.swift
//  Picpic
//
//  Created by Gautier Billard on 03/09/2021.
//

import UIKit

protocol Interactive: UIViewController {
    var interactor: Interactor? { get }
}
class InteractiveControllerPanHandler: NSObject {
    
    weak private (set) var controller: Interactive?
    
    var interactor: Interactor? {
        return controller?.interactor
    }
    var view: UIView {
        return controller?.view ?? UIView()
    }
    
    init(_ controller: Interactive) {
        self.controller = controller
    }
    
    @objc func panHandler(_ recognizer: UIPanGestureRecognizer) {
        
        let percentThreshold: CGFloat = 0.5

        let translation = recognizer.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        guard verticalMovement > 0 else {return}
        guard let interactor = interactor else {return}
        
        switch recognizer.state {
        case .began:
            interactor.hasStarted = true
            controller?.dismiss(animated: true)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
            
        case .ended:
            interactor.hasStarted = false
            if interactor.shouldFinish {
                guard interactor.percentComplete > percentThreshold else {
                    
                    return}
                
                interactor.finish()
            } else {
                
                interactor.cancel()
            }
        case .cancelled:
            
            interactor.hasStarted = false
            interactor.cancel()
        default:
            break
        }
    }
    
}
