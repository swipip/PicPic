//
//  TabBarController.swift
//  Picpic
//
//  Created by Gautier Billard on 03/09/2021.
//

import UIKit

class TabBarController: UITabBarController {
    
    // MARK: UI elements 􀯱
    private lazy var tabBarBorder: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    private lazy var selectionDot: UIView = {
        let view = UIView()
        view.backgroundColor = .systemTeal
        view.layer.cornerRadius = 3 / 2
        return view
    }()
    
    private var dotCenterXPosition: CGFloat {
        let nbControllers = CGFloat(viewControllers?.count ?? 1)
        let width = view.frame.width
        let selectedCtrl = CGFloat(selectedIndex) + 1
        let interval = width / (nbControllers)
        return interval * selectedCtrl - interval/2
    }
    
    private var selectionDotCenterXConstraint: NSLayoutConstraint?
    
    // MARK: View life cycle 􀐰
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        setUp()
    }

    // MARK: UI construction 􀤋
    
    func animateTabBar(on: Bool) {
        
        UIView.animate(withDuration: 0.2) {
            self.tabBar.frame.origin.y += (on ? -100 : 100)
            self.tabBarBorder.frame.origin.y += (on ? -100 : 100)
            self.selectionDot.frame.origin.y += (on ? -100 : 100)
        }
        
    }
    
    func setUp() {
        
        let todayController = TodayController()
        todayController.tabBarItem = .init(
            title: "",
            image: K.images.today,
            selectedImage: K.images.today)
        
        let searchController = SearchController().embedInNav()
        searchController.tabBarItem = .init(
            title: "",
            image: K.images.search,
            selectedImage: K.images.search)
        
        viewControllers = [todayController, searchController]
        
        styleTabBar()
        addBottomBorder()
        addSelectionDot()
        
    }
    private func styleTabBar() {
        
        tabBar.tintColor = .systemTeal
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.backgroundColor = .systemBackground
        
        viewControllers?.map({$0.tabBarItem}).forEach(
            {$0?.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -10, right: 0)})
    }
    
    private func addBottomBorder() {
        let childView: UIView = tabBarBorder
        let mView: UIView = view
        
        view.addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = false
        
        childView.leadingAnchor.constraint(equalTo: mView.leadingAnchor, constant: 0).isActive = true
        childView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        childView.bottomAnchor.constraint(
            equalTo: mView.safeAreaLayoutGuide.bottomAnchor,constant: -tabBar.frame.height).isActive = true
        childView.trailingAnchor.constraint(equalTo: mView.trailingAnchor,constant: 0).isActive = true
    }
    
    private func addSelectionDot() {
        let childView: UIView = selectionDot
        let mView: UIView = view
        
        view.addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = false
        
        selectionDotCenterXConstraint = childView.centerXAnchor.constraint(
            equalTo: mView.leadingAnchor, constant: dotCenterXPosition)
        selectionDotCenterXConstraint?.isActive = true
        childView.centerYAnchor.constraint(
            equalTo: mView.safeAreaLayoutGuide.bottomAnchor, constant: -tabBar.frame.height).isActive = true
        childView.heightAnchor.constraint(equalToConstant: 3).isActive = true
        childView.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
}
extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            self.selectionDotCenterXConstraint?.constant = self.dotCenterXPosition
            self.view.layoutIfNeeded()
        }
    }
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let animator = TabBarControllerAnimator()
        let controller = (toVC as? UINavigationController)?.viewControllers.first
        
        if let _  = controller as? SearchController {
            animator.direction = .fromRight
            return animator
        } else {
            animator.direction = .fromLeft
            return animator
        }
    }
}
