//
//  AlertMaker.swift
//  Picpic
//
//  Created by Gautier Billard on 04/09/2021.
//

import UIKit

class AlertMaker {
    
    weak var controller: UIViewController?
    
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    func displayeNetworkAlert(_ message: String,_ retry: @escaping ()->()) {
        let alert = UIAlertController(title: "Attention", message: message, preferredStyle: .alert)
        alert.view.tintColor = .label
        alert.addAction(.init(title: "Reéssayer", style: .default, handler: { action in
            retry()
        }))
        alert.addAction(.init(title: "Annuler", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        controller?.present(alert, animated: true, completion: nil)
    }
}
